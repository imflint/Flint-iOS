//
//  HomeViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import Domain //TODO: - 로그 지우면서 지우기

import UIKit
import Combine

import View
import ViewModel
import Domain

public final class HomeViewController: BaseViewController<HomeView> {
    
    private let viewModel: HomeViewModel
    
    private let recentSavedDummyItems: [RecentSavedContentItem] = [
        .init(
            posterImageName: "img_background_gradiant_large",
            title: "듄: 파트 2",
            year: 2024,
            availableOn: [.netflix, .disneyPlus, .watcha],
            subscribedOn: [.netflix, .wave]
        ),
        .init(
            posterImageName: "img_background_gradiant_large",
            title: "오펜하이머",
            year: 2023,
            availableOn: [.wave, .tving],
            subscribedOn: [.tving, .wave]
        ),
        .init(
            posterImageName: "img_background_gradiant_large",
            title: "스즈메의 문단속",
            year: 2022,
            availableOn: [.netflix, .watcha],
            subscribedOn: [.netflix]
        )
    ]
    
    // MARK: - Init
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bindActions()
        
        viewModel.fetchRecommendedCollections()
        viewModel.fetchRecentCollections()
    }
    
    // MARK: - Override Points
    
    public override func bind() {
        viewModel.homeRecommendedCollections
            .sink { [weak self] items in
                Log.d(" recommended count: \(items.count)")
                self?.rootView.tableView.reloadSections(
                    IndexSet(integer: HomeTableViewSection.recommend.rawValue),
                    with: .none
                )
            }
            .store(in: &cancellables)
        
        viewModel.recentCollections
            .sink { [weak self] items in
                Log.d(" recent count: \(items.count)")
                self?.rootView.tableView.reloadSections(
                    IndexSet(integer: HomeTableViewSection.recent.rawValue),
                    with: .none
                )
            }
            .store(in: &cancellables)
    }
    
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
    
    // MARK: - Private
    
    private func setTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.separatorStyle = .none
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
        guard let createCollectionViewController = viewControllerFactory?.makeCreateCollectionViewController() else { return }
        navigationController?.pushViewController(createCollectionViewController, animated: true)
    }
    
    private func presentOTTBottomSheet(platforms: [OTTPlatform]) {
        let vc = BaseBottomSheetViewController(
            content: .ott(platforms: platforms)
        )
        present(vc, animated: false)
    }
}


// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    enum HomeTableViewSection: Int, CaseIterable {
        case greeting = 0
        case recommendHeader
        case recommend
        case recentSavedHeader
        case recentSaved
        case recentHeader
        case recent
        case ctaButton
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return HomeTableViewSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let section = HomeTableViewSection(rawValue: indexPath.section) else {
            Log.e("Invalid IndexPath")
            return UITableViewCell()
        }
        
        switch section {
        case .greeting:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeGreetingTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! HomeGreetingTableViewCell
            
            let name = viewModel.homeRecommendedCollections.value.first?.userName ?? "얀비"
            cell.configure(userName: name)
            return cell
            
        case .recommendHeader:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TitleHeaderTableViewCell
            
            cell.configure(style: .normal, title: "Fliner의 추천 컬렉션을 만나보세요", subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요")
            return cell
            
        case .recommend:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell
            cell.configure(items: viewModel.homeRecommendedCollections.value as! [MoreNoMoreCollectionItem])
            return cell
            
        case .recentSavedHeader:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TitleHeaderTableViewCell
            
            cell.configure(style: .normal, title: "최근저장한 콘텐츠", subtitle: "현재 구독 중인 OTT에서 볼 수 있는 작품들이에요")
            return cell
            
        case .recentSaved:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RecentSavedContentTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! RecentSavedContentTableViewCell
            
            cell.configure(items: recentSavedDummyItems)
            
            cell.onTapItem = { [weak self] item in
                let circles = item.availableOn.intersection(item.subscribedOn)
                
                let platforms = CircleOTTPlatform.order
                    .filter { circles.contains($0) }
                    .map { OTTPlatform(circle: $0) }
                
                self?.presentOTTBottomSheet(platforms: platforms)
            }
            return cell
            
        case .recentHeader:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TitleHeaderTableViewCell
            
            cell.configure(style: .more, title: "눈여겨보고 있는 컬렉션", subtitle: "키카님이 최근 살펴본 컬렉션이에요")
            return cell
            
        case .recent:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell
            
            cell.configure(items: viewModel.recentCollections.value as! [MoreNoMoreCollectionItem])
            return cell
            
        case .ctaButton:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeCTAButtonTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! HomeCTAButtonTableViewCell
            
            cell.configure(title: "취향발견하러가기")
            cell.onTap = {
                print("취향발견하러가기 탭") // TODO: 화면 이동 연결
            }
            return cell
        }
    }
}
    
    
    // MARK: - UITableViewDelegate
    
extension HomeViewController: UITableViewDelegate {
        
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            guard let section = HomeTableViewSection(rawValue: indexPath.section) else {
                return UITableView.automaticDimension
            }
            
            switch section {
            case .recommend, .recent:
                return 180
            default:
                return UITableView.automaticDimension
            }
        }
        
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           guard let section = HomeTableViewSection(rawValue: indexPath.section) else {
               return 100
           }

           switch section {
           case .recommend, .recent:
               return 180
           default:
               return 100
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
