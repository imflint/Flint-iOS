//
//  CreateCollectionViewController.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit
import Combine

import Kingfisher

import Domain
import View
import ViewModel

import PhotosUI

public protocol CreateCollectionViewControllerFactory {
    func makeCreateCollectionViewController() -> CreateCollectionViewController
    func makeEditCollectionViewController(collectionId: Int64, prefill: CollectionDetailEntity) -> CreateCollectionViewController
}

public final class CreateCollectionViewController: BaseViewController<CreateCollectionView> {

    // MARK: - Enum

    enum CreateCollectionRow: Int, CaseIterable {
        case header
        case title
        case description
        case visibility
        case addContent
    }

    // MARK: - State

    let mode: CreateCollectionMode

    var collectionTitleText: String = ""
    var collectionDescriptionText: String = ""
    var isPublic: Bool = false
    var selectedVisibility: CreateCollectionVisibilityCell.Visibility?

    var selectedContents: [SavedContentItemViewModel] = []
    var selectedReasonItems: [SelectedContentReasonTableViewCellItem] = []
    var currentPhotoPickerIndex: Int?

    let viewModel: CreateCollectionViewModel

    var headerImage: UIImage?
    var headerImageURL: URL?
    var headerImageKey: String?

    /// 편집 진입 시점의 상태 스냅샷 (변경 감지용)
    private var editInitialSnapshot: EditSnapshot?

    private struct EditSnapshot: Equatable {
        let title: String
        let description: String
        let headerImageKey: String?
        let reasonSnapshots: [ReasonSnapshot]
    }

    private struct ReasonSnapshot: Equatable {
        let contentId: Int64
        let isSpoiler: Bool
        let reasonText: String
        let customImageKeys: [String]
    }

    // MARK: - Init

    public init(
        mode: CreateCollectionMode = .create,
        viewModel: CreateCollectionViewModel,
        viewControllerFactory: ViewControllerFactory? = nil
    ) {
        self.mode = mode
        self.viewModel = viewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func prefill(from entity: CollectionDetailEntity) {
        collectionTitleText = entity.title
        collectionDescriptionText = entity.description

        isPublic = true
        selectedVisibility = .public

        headerImageURL = entity.thumbnailUrl
        headerImageKey = entity.thumbnailUrl?.absoluteString

        let prefillItems: [SelectedContentReasonTableViewCellItem] = entity.contents.compactMap { content in
            guard let contentId = Int64(content.id) else { return nil }
            var item = SelectedContentReasonTableViewCellItem(
                contentId: contentId,
                posterURL: content.imageUrl,
                posterImage: nil,
                title: content.title,
                director: content.director,
                year: String(content.year),
                isSpoiler: content.isSpoiler,
                reasonText: content.reason,
                photos: []
            )
            item.customImageKeys = content.customImageUrls.map { $0.absoluteString }
            return item
        }
        selectedReasonItems = prefillItems

        selectedContents = entity.contents.compactMap { content in
            guard let contentId = Int64(content.id) else { return nil }
            return SavedContentItemViewModel(
                contentId: contentId,
                posterURL: content.imageUrl,
                posterImage: nil,
                title: content.title,
                director: content.director,
                year: String(content.year)
            )
        }

        updateCreatePayload()

        editInitialSnapshot = makeSnapshot()

        // 기존에 등록된 작품 이미지 URL을 UIImage로 로드해서 셀에 반영
        prefillPhotos(from: entity)
    }

    private func makeSnapshot() -> EditSnapshot {
        let reasonSnapshots = selectedReasonItems.map {
            ReasonSnapshot(
                contentId: $0.contentId,
                isSpoiler: $0.isSpoiler,
                reasonText: $0.reasonText ?? "",
                customImageKeys: $0.customImageKeys
            )
        }
        return EditSnapshot(
            title: collectionTitleText,
            description: collectionDescriptionText,
            headerImageKey: headerImageKey,
            reasonSnapshots: reasonSnapshots
        )
    }

    private var hasEditChanges: Bool {
        guard let snapshot = editInitialSnapshot else { return false }
        return snapshot != makeSnapshot()
    }

    private func prefillPhotos(from entity: CollectionDetailEntity) {
        for (index, content) in entity.contents.enumerated() {
            guard !content.customImageUrls.isEmpty else { continue }
            let urls = content.customImageUrls
            let total = urls.count
            let box = LoadedPhotosBox()

            for (i, url) in urls.enumerated() {
                KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                    DispatchQueue.main.async {
                        guard let self else { return }
                        if case .success(let value) = result {
                            box.append(index: i, image: value.image)
                        } else {
                            box.markMissed()
                        }
                        guard box.finishedCount == total else { return }
                        guard index < self.selectedReasonItems.count else { return }
                        self.selectedReasonItems[index].photos = box.orderedImages
                        let indexPath = IndexPath(row: index + 1, section: 1)
                        self.rootView.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
        }
    }

    /// 메인 큐에서만 뮤테이션하므로 안전. Swift 6 concurrency 통과용 @unchecked Sendable.
    private final class LoadedPhotosBox: @unchecked Sendable {
        private var items: [(Int, UIImage)] = []
        private(set) var finishedCount: Int = 0

        func append(index: Int, image: UIImage) {
            items.append((index, image))
            finishedCount += 1
        }

        func markMissed() {
            finishedCount += 1
        }

        var orderedImages: [UIImage] {
            items.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bindViewModel()
        hideKeyboardWhenTappedAround(activeOnAction: false)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.refreshFooterLayout()
    }

    // MARK: - Override Points

    public override func setUI() {
        super.setUI()

        view.backgroundColor = DesignSystem.Color.background

        setNavigationBar(
            .init(
                left: .back,
                right: .none,
                backgroundStyle: .solid(DesignSystem.Color.background)
            ),
            onTapLeft: { [weak self] in
                self?.didTapBack()
            }
        )
    }

    private func didTapBack() {
        if case .edit = mode, hasEditChanges {
            presentExitConfirmModal()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func presentExitConfirmModal() {
        let host: UIView = navigationController?.view ?? view
        var modalRef: Modal?
        let modal = Modal(
            image: DesignSystem.Icon.Gradient.pencil,
            title: "컬렉션 수정을 그만둘까요?",
            caption: "변경한 내용은 저장되지 않아요.",
            leftButtonTitle: "취소",
            rightButtonTitle: "나가기",
            rightButtonColor: DesignSystem.Color.error500,
            onLeft: { _ in modalRef?.dismiss() },
            onRight: { [weak self] _ in
                modalRef?.dismiss {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        )
        modalRef = modal
        modal.show(in: host)
    }
}
