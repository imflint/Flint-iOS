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

public final class CollectionDetailViewController: BaseViewController<CollectionDetailView> {

    // MARK: - Enum

    private enum Row {
        case header
        case description
        case film(Int)
        case saveUsers
    }

    // MARK: - Property

    private let viewModel: CollectionDetailViewModel

    private var entity: CollectionDetailEntity?
    private var rows: [Row] = [.header, .description, .saveUsers]
    private var bookmarkedUsers: CollectionBookmarkUsersEntity?

    // Input
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let tapHeaderSaveSubject = PassthroughSubject<Bool, Never>()

    // MARK: - Init

    public init(viewModel: CollectionDetailViewModel, viewControllerFactory: ViewControllerFactory) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystem.Color.background
        setupTableView()
        setNavigationBar(.init(left: .back, backgroundStyle: .clear))
    }

    // MARK: - Bind

    public override func bind() {
        let input = CollectionDetailViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            tapHeaderSave: tapHeaderSaveSubject.eraseToAnyPublisher()
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
                case .loaded(let detail, let bookmarkedUsers):
                    self.entity = detail
                    self.bookmarkedUsers = bookmarkedUsers
                    self.apply(entity: detail)
                case .failed(let message):
                    print("Collection detail load failed:", message)
                }
            }
            .store(in: &cancellables)

        viewDidLoadSubject.send(())
    }

    private func apply(entity: CollectionDetailEntity) {
        self.entity = entity

        var result: [Row] = [.header, .description]
        result += (0..<entity.contents.count).map { .film($0) }
        result += [.saveUsers]
        self.rows = result

        rootView.tableView.reloadData()
    }
    
    private func presentSavedUsersBottomSheet(users: [SavedUserRowItem]) {
        guard !users.isEmpty else { return }
        
        let sheet = BaseBottomSheetViewController(content: .savedUsers(users: users))
        
        sheet.onSelectSavedUser = { [weak self, weak sheet] user in
            guard let self else { return }
            
            sheet?.dismiss(animated: false) { [weak self] in
                guard let self else { return }
                
                guard let factory = self.viewControllerFactory else { return }
                let profileVC = factory.makeProfileViewController(target: .user(userId: user.userId))
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
                userId: user.userId,
                profileImageURL: user.profileImageUrl,
                nickname: user.nickname,
                isVerified: user.userRole == "FLINER"
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

            cell.configure(title: title, isSaved: isSaved)
            cell.onTapSave = { [weak self] isSaved in
                self?.tapHeaderSaveSubject.send(isSaved)
            }
            return cell

        case .description:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailDescriptionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailDescriptionTableViewCell

            cell.selectionStyle = .none

            let author = entity?.author?.nickname ?? ""
            let dateText = entity?.createdAt ?? ""
            let description = entity?.description ?? ""
            let isVerified = (entity?.author?.userRole == "FLINER")

            cell.configure(
                author: author,
                isVerified: isVerified,
                dateText: dateText,
                description: description
            )
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
