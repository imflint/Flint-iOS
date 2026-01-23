//
//  HomeViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit

import View
import ViewModel

import Domain

public final class HomeViewController: BaseViewController<HomeView> {
    
    private let viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel, viewControllerFactory: ViewControllerFactory? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bindActions()
        
        bind()
        viewModel.load()
    }
    
    // MARK: - Override Points
    
    public override func setUI() {
        view.backgroundColor = DesignSystem.Color.background
        
        setNavigationBar(
            .init(
                left: .logo,
                right: .none,
                backgroundStyle: .solid(DesignSystem.Color.background)
            )
        )
        
        statusBarBackgroundView.isHidden = true
    }
    
    public override func bind() {
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private
    
    private func setTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }
    
    private func registerCells() {
        rootView.tableView.register(HomeGreetingTableViewCell.self)
        rootView.tableView.register(TitleHeaderTableViewCell.self)
        rootView.tableView.register(MoreNoMoreCollectionTableViewCell.self)
        rootView.tableView.register(RecentSavedContentTableViewCell.self)
        rootView.tableView.register(HomeCTAButtonTableViewCell.self)
    }
    
    private func bindActions() {
        rootView.floatingButton.addTarget(self, action: #selector(didTapFab), for: .touchUpInside)
    }
    
    @objc private func didTapFab() {
        Log.d("didTapFab")
        let factory = viewControllerFactory
        ?? (parent as? TabBarViewController)?.viewControllerFactory
        
        guard let factory else {
            Log.d("factory is nil")
            return
        }
        
        let vc = factory.makeCreateCollectionViewController()
        
        let nav = navigationController ?? parent?.navigationController
        guard let nav else {
            Log.d("nav is nil -> cannot push")
            return
        }
        
        nav.pushViewController(vc, animated: true)
    }
    
    
    private func map(_ style: HomeViewModel.TitleHeaderStyle) -> TitleHeaderTableViewCell.TitleHeaderStyle {
        switch style {
        case .normal: return .normal
        case .more: return .more
        }
    }
    private func presentOTTBottomSheet(platforms: [OTTPlatform]) {
           let vc = BaseBottomSheetViewController(content: .ott(platforms: platforms))
           present(vc, animated: false)
    }
}


// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = viewModel.sections[indexPath.section].rows[indexPath.row]
        
        switch row {
            
        case .greeting(let userName):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeGreetingTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! HomeGreetingTableViewCell
            cell.configure(userName: userName)
            return cell
            
        case .header(let style, let title, let subtitle):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TitleHeaderTableViewCell
            
            cell.configure(style: map(style), title: title, subtitle: subtitle)
            return cell
            
        case .fliner(let items):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell
            cell.configure(items: items)
            return cell
            
        case .ctaButton(let title):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeCTAButtonTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! HomeCTAButtonTableViewCell
            cell.configure(title: title)
            return cell
        case .recentSavedContents(let items):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RecentSavedContentTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! RecentSavedContentTableViewCell
            
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


// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = viewModel.sections[indexPath.section].rows[indexPath.row]
        
        switch row {
        case .fliner:
            return 180
        default:
            return UITableView.automaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        48
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
