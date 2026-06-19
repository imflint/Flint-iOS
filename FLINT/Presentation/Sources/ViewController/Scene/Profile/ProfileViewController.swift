//
//  ProfileViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/19/26.
//

import Combine
import UIKit

import SnapKit
import Then

import Domain

import View
import ViewModel

public protocol ProfileViewControllerFactory {
    func makeProfileViewController() -> ProfileViewController
    func makeProfileViewController(target: UserTarget) -> ProfileViewController
}

public final class ProfileViewController: BaseViewController<ProfileView> {

    private let profileViewModel: ProfileViewModel

    public init(
        profileViewModel: ProfileViewModel,
        viewControllerFactory: ViewControllerFactory,
    ) {
        self.profileViewModel = profileViewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
        profileViewModel.load()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(.init(left: .back, backgroundStyle: .clear))

    }

    
    private func setupTableView() {
        let tableView = rootView.tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProfileHeaderTableViewCell.self)
        tableView.register(PreferenceRankedChipTableViewCell.self)
        tableView.register(TitleHeaderTableViewCell.self)
        tableView.register(MoreNoMoreCollectionTableViewCell.self)
        tableView.register(RecentSavedContentTableViewCell.self)
    }
    
    public override func bind() {
        profileViewModel.$rows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func map(_ style: ProfileViewModel.TitleHeaderStyle) -> TitleHeaderTableViewCell.TitleHeaderStyle {
        switch style {
        case .normal: return .normal
        case .more: return .more
        }
    }

    private func presentOTTBottomSheet(platforms: [OTTPlatform]) {
        let vc = BaseBottomSheetViewController(content: .ott(platforms: platforms))
        present(vc, animated: false)
    }

    private func pushCollectionDetail(collectionIdString: String) {
        guard let collectionId = Int64(collectionIdString) else {
            print("invalid collectionId:", collectionIdString)
            return
        }
        guard let vc = viewControllerFactory?.makeCollectionDetailViewController(collectionId: collectionId) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let row = profileViewModel.rows[section]
        switch row {
        case .profileHeader:
            return 6
        case .titleHeader:
            return 0
        case .preferenceChips:
            return 32
        case .keywordGraph:
            return 48
        case .myCollections, .savedCollections:
            return 24
        case .savedContents:
            return 24
        }
    }

    // (선택) 셀 선택 막고 싶으면 이미 selectionStyle = .none이라 없어도 됨
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        profileViewModel.rows.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = profileViewModel.rows[indexPath.section]

        switch row {
        case let .profileHeader(nickname, profileImageUrl, isFliner):
            let cell = tableView.dequeueReusableCell(ProfileHeaderTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configure(nickname: nickname, profileImageUrl: profileImageUrl, isFliner: isFliner)
            return cell

        case let .preferenceChips(keywords):
            let cell = tableView.dequeueReusableCell(PreferenceRankedChipTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configure(keywords: keywords)
            return cell

        case let .keywordGraph(keywords):
            let cell = tableView.dequeueReusableCell(KeywordGraphTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configure(keywords: keywords)
            return cell

        case let .titleHeader(style, title, subtitle, showInfo):
            let cell = tableView.dequeueReusableCell(TitleHeaderTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configure(style: map(style), title: title, subtitle: subtitle, showInfo: showInfo)
            return cell

        case let .myCollections(items):
            let cell = tableView.dequeueReusableCell(MoreNoMoreCollectionTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configure(items: items)
            cell.onSelectItem = { [weak self] entity in
                self?.pushCollectionDetail(collectionIdString: entity.id)
            }
            return cell

        case let .savedCollections(items):
            let cell = tableView.dequeueReusableCell(MoreNoMoreCollectionTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configure(items: items)
            cell.onSelectItem = { [weak self] entity in
                self?.pushCollectionDetail(collectionIdString: entity.id)
            }
            return cell

        case let .savedContents(items):
            let cell = tableView.dequeueReusableCell(RecentSavedContentTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.configure(items: items)
            cell.onTapItem = { [weak self] content in
                guard let self else { return }

                let platforms: [OTTPlatform] = content.ottList.compactMap { ott in
                    OTTPlatform.fromServerName(ott.ottName)
                }

                if platforms.isEmpty {
                    print("ottList 비어있음 or 매핑 실패. contentId:", content.id)
                }

                self.presentOTTBottomSheet(platforms: platforms)
            }
            return cell
        }
    }
}
