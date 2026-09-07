//
//  CreateCollectionViewController.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit
import Combine

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
                guard let self else { return }
                if self.hasUnsavedContent {
                    self.presentExitConfirmModal()
                } else {
                    if let nav = self.navigationController, nav.viewControllers.count > 1 {
                        nav.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            }
        )
    }
}
