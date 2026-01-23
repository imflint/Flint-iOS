//
//  ProfileViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/19/26.
//

import UIKit
import Combine

import SnapKit
import Then

import Domain
import View
import ViewModel

public final class ProfileViewController: BaseViewController<ProfileView> {
    
    private let profileViewModel: ProfileViewModel
    
    public init(profileViewModel: ProfileViewModel,
                viewControllerFactory: ViewControllerFactory) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
        profileViewModel.load()
    }
    
    private func setupTableView() {
        let tableView = rootView.tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            ProfileHeaderTableViewCell.self,
            forCellReuseIdentifier: ProfileHeaderTableViewCell.reuseIdentifier
        )
        tableView.register(
            PreferenceRankedChipTableViewCell.self,
            forCellReuseIdentifier: PreferenceRankedChipTableViewCell.reuseIdentifier
        )
        tableView.register(
            TitleHeaderTableViewCell.self,
            forCellReuseIdentifier: TitleHeaderTableViewCell.reuseIdentifier
        )
        tableView.register(
            MoreNoMoreCollectionTableViewCell.self,
            forCellReuseIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier
        )
        tableView.register(
            RecentSavedContentTableViewCell.self,
            forCellReuseIdentifier: RecentSavedContentTableViewCell.reuseIdentifier
        )
    }
    
    public override func bind() {
        profileViewModel.$rows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func map(_ style: ProfileViewModel.TitleHeaderStyle) -> TitleHeaderTableViewCell.HeaderStyle {
        switch style {
        case .normal: return .normal
        case .more: return .more
        }
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
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ProfileHeaderTableViewCell
            cell.selectionStyle = .none
            cell.configure(nickname: nickname, profileImageUrl: profileImageUrl, isFliner: isFliner)
            return cell

        case let .preferenceChips(keywords):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PreferenceRankedChipTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PreferenceRankedChipTableViewCell
            cell.selectionStyle = .none
            cell.configure(entities: keywords)
            return cell

        case let .titleHeader(style, title, subtitle):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TitleHeaderTableViewCell
            cell.selectionStyle = .none
            cell.configure(style: map(style), title: title, subtitle: subtitle)
            return cell

        case let .myCollections(items):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell
            cell.selectionStyle = .none

            cell.configure(items: items)

            cell.onSelectItem = { entity in
                print("컬렉션 선택:", entity.id)
            }
            return cell

        case let .savedCollections(items):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell
            cell.selectionStyle = .none

            cell.configure(items: items)

            cell.onSelectItem = { entity in
                print("저장 컬렉션 선택:", entity.id)
            }
            return cell
            
        case let .savedContents(items):
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSavedContentTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! RecentSavedContentTableViewCell
            cell.selectionStyle = .none
            cell.configure(items: items)
            cell.onTapItem = {entity in
                print("저장 컨텐츠 선택: ", entity.id)
            }
            return cell
        }
    }
}
