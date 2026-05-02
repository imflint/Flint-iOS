//
//  SettingViewController.swift
//  Presentation
//
//  Created by 소은 on 5/2/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

import Domain

import View
import ViewModel


// MARK: - SettingViewControllerFactory

public protocol SettingViewControllerFactory {
    func makeSettingViewController() -> SettingViewController
}

// MARK: - SettingViewController

public final class SettingViewController: BaseViewController<SettingView> {
    
    // MARK: - ViewModel
    
    public let settingViewModel: any SettingViewModel
    
    // MARK: - DataSource
    
    private var tableViewDataSource: UITableViewDiffableDataSource<SettingSection, SettingItem>?
    
    // MARK: - Properties
    
    private enum SettingSection: Int, CaseIterable {
        case account
        case menu
    }
    
    private enum SettingItem: Hashable {
        case account(String)
        case menu(String)
    }
    
    private let menuItems = ["개인정보 정책", "이용약관", "로그아웃"]
    
    // MARK: - Initialization
    
    public init(settingViewModel: any SettingViewModel, viewControllerFactory: any ViewControllerFactory) {
        self.settingViewModel = settingViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(
            left: .back,
            title: "설정",
            backgroundStyle: .solid(DesignSystem.Color.background)  
        ))
        setupTableView()
        setupActions()
    }
    
    // MARK: - Bind
    
    public override func bind() {
        settingViewModel.userProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                guard let self else { return }
                updateSnapshot(profile: profile)
            }
            .store(in: &cancellables)
        
        settingViewModel.navigateToEditProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigateToEditProfile()
            }
            .store(in: &cancellables)
        
        settingViewModel.navigateToAccount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigateToAccount()
            }
            .store(in: &cancellables)
        
        settingViewModel.navigateToPrivacyPolicy
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigateToPrivacyPolicy()
            }
            .store(in: &cancellables)
        
        settingViewModel.navigateToTermsOfService
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigateToTermsOfService()
            }
            .store(in: &cancellables)
        
        settingViewModel.showLogoutAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showLogoutAlert()
            }
            .store(in: &cancellables)
        
        settingViewModel.showWithdrawalAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showWithdrawalAlert()
            }
            .store(in: &cancellables)
        
        settingViewModel.logoutSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.handleLogoutSuccess()
            }
            .store(in: &cancellables)
    }
}

// MARK: - TableView

extension SettingViewController {
    private func setupTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = tableViewDataSource
        
        tableViewDataSource = UITableViewDiffableDataSource<SettingSection, SettingItem>(
            tableView: rootView.tableView,
            cellProvider: { tableView, indexPath, item in 
                
                switch item {
                case let .account(id):
                    let cell = tableView.dequeueReusableCell(withIdentifier: SettingAccountCell.identifier, for: indexPath) as! SettingAccountCell
                    cell.configure(with: id)
                    return cell
                    
                case let .menu(title):
                    let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuCell.identifier, for: indexPath) as! SettingMenuCell
                    cell.configure(with: title)
                    return cell
                }
            }
        )
        
        updateSnapshot(profile: settingViewModel.userProfile.value)
    }
    
    private func updateSnapshot(profile: UserProfileEntity?) {
        var snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingItem>()
        
        snapshot.appendSections([.account])
        if let profile = profile {
            snapshot.appendItems([.account(profile.id)], toSection: .account)
        }
        
        snapshot.appendSections([.menu])
        snapshot.appendItems(menuItems.map { .menu($0) }, toSection: .menu)
        
        tableViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setupActions() {
        rootView.withdrawalButton.addAction(
            UIAction(weak: self, handler: SettingViewController.didTapWithdrawalButton),
            for: .touchUpInside
        )
    }
    
    private func didTapWithdrawalButton(_ action: UIAction) {
        settingViewModel.withdrawalTapped()
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = SettingSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .account:
            settingViewModel.accountTapped()
            
        case .menu:
            switch indexPath.row {
            case 0:
                settingViewModel.privacyPolicyTapped()
            case 1:
                settingViewModel.termsOfServiceTapped()
            case 2:
                settingViewModel.logoutTapped()
            default:
                break
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 68
        }
        return 56
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0, let profile = settingViewModel.userProfile.value {
            let headerView = SettingProfileHeaderView()
            headerView.configure(with: profile)
            headerView.onEditProfileTapped = { [weak self] in
                self?.settingViewModel.editProfileTapped()
            }
            return headerView
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 112 : 0 
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - Navigation

private extension SettingViewController {
    func navigateToEditProfile() {
        print("Navigate to Edit Profile")
    }
    
    func navigateToAccount() {
        print("Navigate to Account")
    }
    
    func navigateToPrivacyPolicy() {
        print("Navigate to Privacy Policy")
    }
    
    func navigateToTermsOfService() {
        print("Navigate to Terms of Service")
    }
    
    func showLogoutAlert() {
        var modal: Modal?
        
        modal = Modal(
            image: DesignSystem.Icon.Gradient.people,
            caption: "로그아웃 하시겠습니까?",
            leftButtonTitle: "취소",
            rightButtonTitle: "로그아웃",
            rightButtonColor: DesignSystem.Color.primary400,
            onLeft: { _ in
                modal?.dismiss {
                    modal = nil
                }
            },
            onRight: { [weak self] _ in
                modal?.dismiss {
                    (self?.settingViewModel as? DefaultSettingViewModel)?.performLogout()
                    modal = nil
                }
            }
        )
        
        guard let modal else { return }
        modal.show(in: view)
    }
    
    func showWithdrawalAlert() {
        print("Navigate to Withdrawal Page")
    }
    
    func handleLogoutSuccess() {
        // 우선 .. 로그인 화면으로 이동 로직읽어봐야함
        guard let loginVC = viewControllerFactory?.makeLoginViewController() else { return }
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        if let window = view.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.rootViewController = navigationController
            }
        }
    }
}
