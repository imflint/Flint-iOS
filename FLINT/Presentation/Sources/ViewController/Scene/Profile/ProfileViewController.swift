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
    }

    public override func bind() {
        profileViewModel.$rows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)
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
        case let .profileHeader(nickname, isFliner):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ProfileHeaderTableViewCell

            cell.selectionStyle = .none
            cell.configure(nickname: nickname, isFliner: isFliner)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        6
    }
}


//public final class ProfileViewController: BaseViewController<ProfileView> {
//    
//    private let profileViewModel: ProfileViewModel
//    
//    public init(profileViewModel: ProfileViewModel,
//                viewControllerFactory: ViewControllerFactory) {
//        self.profileViewModel = profileViewModel
//        super.init(nibName: nil, bundle: nil)
//        self.viewControllerFactory = viewControllerFactory
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        bind()
//        profileViewModel.load()
//    }
//    
//    private func setupTableView() {
//        let tableView = rootView.tableView
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        tableView.register(ProfileHeaderTableViewCell.self, forCellReuseIdentifier: ProfileHeaderTableViewCell.reuseIdentifier)
//        tableView.register(TitleHeaderTableViewCell.self, forCellReuseIdentifier: TitleHeaderTableViewCell.reuseIdentifier)
//        tableView.register(PreferenceRankedChipTableViewCell.self, forCellReuseIdentifier: PreferenceRankedChipTableViewCell.reuseIdentifier)
//        tableView.register(MoreNoMoreCollectionTableViewCell.self, forCellReuseIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier)
//        tableView.register(RecentSavedContentTableViewCell.self, forCellReuseIdentifier: RecentSavedContentTableViewCell.reuseIdentifier)
//    }
//    
//    public override func bind() {
//        profileViewModel.$rows
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.rootView.tableView.reloadData()
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func map(_ style: ProfileViewModel.TitleHeaderStyle) -> TitleHeaderTableViewCell.HeaderStyle {
//        switch style {
//        case .normal: return .normal
//        case .more: return .more
//        }
//    }
//    
//    private func didTapMore(for indexPath: IndexPath) {
//        let row = profileViewModel.rows[indexPath.section]
//        if case .titleHeader = row {
//            print("More tapped at row \(indexPath.row)")
//        }
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension ProfileViewController: UITableViewDataSource {
//    
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        profileViewModel.rows.count
//    }
//    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let row = profileViewModel.rows[indexPath.section]
//        
//        switch row {
//        case let .profileHeader(nickname, isFliner):
//            guard let cell = tableView.dequeueReusableCell(
//                withIdentifier: ProfileHeaderTableViewCell.reuseIdentifier,
//                for: indexPath
//            ) as? ProfileHeaderTableViewCell else { return UITableViewCell() }
//            
//            cell.selectionStyle = .none
//            cell.configure(nickname: nickname, isFliner: isFliner)
//            return cell
//            
//        case let .titleHeader(style, title, subtitle):
//            guard let cell = tableView.dequeueReusableCell(
//                withIdentifier: TitleHeaderTableViewCell.reuseIdentifier,
//                for: indexPath
//            ) as? TitleHeaderTableViewCell else { return UITableViewCell() }
//            
//            cell.configure(style: map(style), title: title, subtitle: subtitle)
//            cell.onTapMore = { [weak self] in
//                self?.didTapMore(for: indexPath)
//            }
//            return cell
//            
//        case let .preferenceChips(keywords):
//            guard let cell = tableView.dequeueReusableCell(
//                withIdentifier: PreferenceRankedChipTableViewCell.reuseIdentifier,
//                for: indexPath
//            ) as? PreferenceRankedChipTableViewCell else { return UITableViewCell() }
//            
//            cell.configure(keywords: keywords)
//            return cell
//            
//        case let .collection(items):
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
//                for: indexPath
//            ) as! MoreNoMoreCollectionTableViewCell
//            
//            cell.configure(items: items)
//            cell.onSelectItem = { item in
//                print(item.title, item.userName)
//            }
//            return cell
//            
//        case let .recentSaved(items):
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: RecentSavedContentTableViewCell.reuseIdentifier,
//                for: indexPath
//            ) as! RecentSavedContentTableViewCell
//            
//            cell.configure(items: items)
//            cell.onTapItem = { item in
//                Log.d("최근 저장 작품 탭:", item)
//            }
//            return cell
//        }
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension ProfileViewController: UITableViewDelegate {
//    
//    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        UIView()
//    }
//    
//    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let row = profileViewModel.rows[section]
//        switch row {
//        case .profileHeader: return 6
//        case .titleHeader: return 0
//        case .preferenceChips: return 48
//        case .collection: return 24
//        case .recentSaved: return 24
//        }
//    }
//}
