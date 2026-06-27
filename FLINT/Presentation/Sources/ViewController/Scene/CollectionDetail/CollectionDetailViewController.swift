//
//  CollectionDetailViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/21/26.
//

import UIKit
import Combine

import SnapKit

import Entity
import View
import ViewModel

public protocol CollectionDetailViewControllerFactory {
    func makeCollectionDetailViewController(collectionId: Int64) -> CollectionDetailViewController
}

public final class CollectionDetailViewController: BaseViewController<CollectionDetailView> {

    // MARK: - Enum

    private enum Row {
        case header
        case description
        case filmImage(Int)
        case film(Int)
        case saveUsers
    }

    // MARK: - Property

    private let viewModel: CollectionDetailViewModel

    private var entity: CollectionDetailEntity?
    private var rows: [Row] = [.header, .description, .saveUsers]
    private var bookmarkedUsers: CollectionBookmarkUsersEntity?
    private var isOwner: Bool = false
    private var kebabMenu: KebabMenu?

    /// kebab → 신고 탭 시 호출. 인자는 신고 대상 컬렉션 id.
    /// 신고 화면은 별도 담당자가 구현 예정이므로, 호출부에서 closure 만 주입하면 됨.
    public var onTapReport: ((Int64) -> Void)?

    // Input
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let tapHeaderSaveSubject = PassthroughSubject<Bool, Never>()
    private let tapContentBookmarkSubject = PassthroughSubject<Int64, Never>()

    // MARK: - Init

    public init(viewModel: CollectionDetailViewModel, viewControllerFactory: ViewControllerFactory) {
        self.viewModel = viewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystem.Color.background
        setupTableView()
        setNavigationBar(
            .init(left: .back, right: .kebab, backgroundStyle: .clear),
            onTapRight: { [weak self] in
                self?.didTapKebab()
            }
        )
    }

    // MARK: - Bind

    public override func bind() {
        let input = CollectionDetailViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            tapHeaderSave: tapHeaderSaveSubject.eraseToAnyPublisher(),
            tapContentBookmark: tapContentBookmarkSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    break
                case .loading:
                    break
                case .loaded(let detail, let bookmarkedUsers, let isOwner):
                    self.entity = detail
                    self.bookmarkedUsers = bookmarkedUsers
                    self.isOwner = isOwner
                    self.apply(entity: detail)
                case .failed(let message):
                    print("Collection detail load failed:", message)
                }
            }
            .store(in: &cancellables)

        viewModel.deleteSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.deleteFailure
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("Collection delete failed:", error)
            }
            .store(in: &cancellables)

        viewDidLoadSubject.send(())
    }

    private func apply(entity: CollectionDetailEntity) {
        self.entity = entity

        var result: [Row] = [.header, .description]
        result += entity.contents.enumerated().flatMap { idx, content -> [Row] in
            content.customImageUrls.isEmpty ? [.film(idx)] : [.filmImage(idx), .film(idx)]
        }
        result += [.saveUsers]
        self.rows = result

        rootView.tableView.reloadData()
    }

    // MARK: - Action

    private func didTapKebab() {
        kebabMenu?.dismiss()

        let items: [KebabMenuItem] = isOwner
            ? [
                KebabMenuItem(title: "수정") { [weak self] in
                    self?.didTapEdit()
                },
                KebabMenuItem(
                    title: "삭제",
                    titleColor: DesignSystem.Color.error500
                ) { [weak self] in
                    self?.didTapDelete()
                }
            ]
            : [
                KebabMenuItem(title: "신고") { [weak self] in
                    self?.didTapReport()
                }
            ]

        let menu = KebabMenu(items: items)
        let anchorFrame = navigationBarView.rightButtonFrame(in: view)
        menu.show(in: view, anchorFrame: anchorFrame)
        kebabMenu = menu
    }

    private func didTapEdit() {
        guard let entity, let collectionId = Int64(entity.id) else { return }
        guard let factory = viewControllerFactory else { return }
        let editVC = factory.makeEditCollectionViewController(collectionId: collectionId, prefill: entity)
        navigationController?.pushViewController(editVC, animated: true)
    }

    private func didTapDelete() {
        let hostView: UIView = navigationController?.view ?? view
        var modalRef: Modal?
        let modal = Modal(
            image: DesignSystem.Icon.Gradient.trash,
            title: "컬렉션을 삭제할까요?",
            caption: "삭제한 컬렉션은 복구할 수 없어요.",
            leftButtonTitle: "취소",
            rightButtonTitle: "삭제",
            rightButtonColor: DesignSystem.Color.error500,
            onLeft: { _ in modalRef?.dismiss() },
            onRight: { [weak self] _ in
                modalRef?.dismiss {
                    self?.viewModel.deleteCollection()
                }
            }
        )
        modalRef = modal
        modal.show(in: hostView)
    }

    private func didTapReport() {
        guard let entity, let collectionId = Int64(entity.id) else { return }
        guard let factory = viewControllerFactory else { return }
        let reportVC = factory.makeReportViewController(collectionId: collectionId)
        navigationController?.pushViewController(reportVC, animated: true)
    }
    
    private func presentSavedUsersBottomSheet(users: [SavedUserRowItem]) {
        guard !users.isEmpty else { return }
        
        let sheet = BaseBottomSheetViewController(content: .savedUsers(users: users))
        
        sheet.onSelectSavedUser = { [weak self, weak sheet] user in
            guard let self else { return }
            
            sheet?.dismiss(animated: false) { [weak self] in
                guard let self else { return }
                
                guard let factory = self.viewControllerFactory else { return }
                let profileVC = factory.makeProfileViewController(target: .user(id: Int64(user.userId)!))
                navigationController?.setNavigationBarHidden(false, animated: false)
                navigationController?.pushViewController(profileVC, animated: true)
            }
        }
        
        present(sheet, animated: false)
    }

    
    private func makeSavedUserRowItems() -> [SavedUserRowItem] {
        let users = bookmarkedUsers?.users ?? []
        return users.map { user in
            SavedUserRowItem(
                userId: user.id,
                profileImageURL: user.profileImageUrl,
                nickname: user.nickname,
                isVerified: user.role == .fliner
            )
        }
    }


    // MARK: - Setup

    public override func setBaseLayout() {
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(statusBarBackgroundView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        rootView.snp.makeConstraints {
            $0.top.equalTo(statusBarBackgroundView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        let tableView = rootView.tableView

        tableView.backgroundColor = DesignSystem.Color.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.insetsContentViewsToSafeArea = false
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(CollectionDetailHeaderTableViewCell.self)
        tableView.register(CollectionDetailDescriptionTableViewCell.self)
        tableView.register(CollectionDetailFilmImageTableViewCell.self)
        tableView.register(CollectionDetailFilmTableViewCell.self)
        tableView.register(CollectionSaveUserTableViewCell.self)

        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource

extension CollectionDetailViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch rows[indexPath.row] {

        case .header:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailHeaderTableViewCell

            cell.selectionStyle = .none

            let title = entity?.title ?? ""
            let isSaved = entity?.isBookmarked ?? false
            let thumbnailURL = entity?.thumbnailUrl

            cell.configure(title: title, isSaved: isSaved, thumbnailURL: thumbnailURL)
            cell.onTapSave = { [weak self] isSaved in
                guard let self else { return }
                self.tapHeaderSaveSubject.send(isSaved)

                if isSaved {
                    Toast.action(
                        image: DesignSystem.Icon.Gradient.bookmark,
                        title: "취향이 하나 더 쌓였어요",
                        actionTitle: "저장한 컬렉션 보러가기",
                        action: { [weak self] _ in
                            guard let self else { return }
                            guard let factory = self.viewControllerFactory else { return }
                            let vc = factory.makeSavedCollectionListViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    ).show()
                } else {
                    Toast.text("컬렉션 저장이 취소되었어요").show()
                }
            }
            return cell

        case .description:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailDescriptionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailDescriptionTableViewCell

            cell.selectionStyle = .none

            let author = entity?.author.nickname ?? ""
            let dateText = entity?.createdAt ?? ""
            let description = entity?.description ?? ""
            let isVerified = (entity?.author.role == .fliner)

            cell.configure(
                author: author,
                isVerified: isVerified,
                dateText: dateText,
                description: description
            )
            return cell

        case .filmImage(let idx):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailFilmImageTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailFilmImageTableViewCell

            cell.selectionStyle = .none

            let urls = entity?.contents[safe: idx]?.customImageUrls ?? []
            cell.configure(imageURLs: urls)

            return cell

        case .film(let idx):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailFilmTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailFilmTableViewCell

            cell.selectionStyle = .none

            guard let item = entity?.contents[safe: idx] else {
                // 데이터 없으면 재사용 셀 초기화만
                cell.configureSpoiler(isSpoiler: false)
                cell.onTapRevealSpoiler = nil
                return cell
            }

            cell.configure(item: item)

            cell.onTapRevealSpoiler = { [weak cell] in
                cell?.configureSpoiler(isSpoiler: false)
            }

            cell.onTapBookmark = { [weak self] isBookmarked, _ in
                guard let self else { return }
                guard let contentId = Int64(item.id) else { return }
                self.tapContentBookmarkSubject.send(contentId)

                if isBookmarked {
                    Toast.text("작품을 저장했어요").show()
                } else {
                    Toast.text("작품 저장을 취소했어요").show()
                }
            }

            return cell

        case .saveUsers:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionSaveUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionSaveUserTableViewCell

            cell.selectionStyle = .none

            let urls = (bookmarkedUsers?.users ?? []).map { $0.profileImageUrl }
            cell.configure(title: "이 컬렉션을 저장한 사람들", profileImageURLs: urls)

            cell.onTapMore = { [weak self] in
                guard let self else { return }
                    let items = self.makeSavedUserRowItems()
                    self.presentSavedUsersBottomSheet(users: items)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension CollectionDetailViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Safe Index

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
