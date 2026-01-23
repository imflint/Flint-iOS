//
//
//  HomeViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit
import Combine

import Domain
import View
import ViewModel

public final class HomeViewController: BaseViewController<HomeView> {

    // MARK: - Dependency

    private let viewModel: HomeViewModel

    public convenience init() {
        self.init(viewModel: StubHomeViewModel(userName: "얀비"))
    }

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bindActions()
        bindViewModel()

        viewModel.fetchRecommendedCollections()
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

    private func bindViewModel() {
        viewModel.sections
            .sink(receiveValue: { [weak self] _ in
                self?.rootView.tableView.reloadData()
            })
            .store(in: &cancellables)

        viewModel.fetchFailure
            .sink(receiveValue: { error in
                Log.e("fetchRecommendedCollections failed: \(error)")
            })
            .store(in: &cancellables)
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

    private func presentOTTBottomSheet(platforms: [OTTPlatform]) {
        let vc = BaseBottomSheetViewController(
            content: .ott(platforms: platforms)
        )
        present(vc, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.value.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections.value[section].rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = viewModel.sections.value[indexPath.section].rows[indexPath.row]

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

            let uiStyle: TitleHeaderTableViewCell.HeaderStyle = {
                switch style {
                case .normal: return .normal
                case .more: return .more
                }
            }()

            cell.configure(style: uiStyle, title: title, subtitle: subtitle)

            if uiStyle == .more {
                cell.onTapMore = { [weak self] in
                    let vc = CollectionFolderListViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                cell.onTapMore = nil
            }

            return cell

        case .fliner(let entities):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell

            let items: [MoreNoMoreCollectionItem] = entities.map {
                .init(
                    id: UUID(),
                    image: UIImage(named: "img_background_gradiant_middle"),
                    profileImage: UIImage(named: "img_profile_blue"),
                    title: $0.title,
                    userName: $0.userName
                )
            }

            cell.configure(items: items)
            return cell

        case .recentSaved(let items):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RecentSavedContentTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! RecentSavedContentTableViewCell

            cell.configure(items: items)

            cell.onTapItem = { [weak self] item in
                let circles = item.availableOn.intersection(item.subscribedOn)

                let platforms = CircleOTTPlatform.order
                    .filter { circles.contains($0) }
                    .map { OTTPlatform(circle: $0) }

                self?.presentOTTBottomSheet(platforms: platforms)
            }

            return cell

        case .ctaButton(let title):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeCTAButtonTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! HomeCTAButtonTableViewCell

            cell.configure(title: title)
            cell.onTap = {
                print("취향발견하러가기 탭") // TODO: 화면 이동 연결
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        48
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

// MARK: - Stub ViewModel (TabBar 호환용)

private final class StubHomeViewModel: HomeViewModel {

    var sections: CurrentValueSubject<[HomeSectionModel], Never>
    var fetchSuccess: PassthroughSubject<Void, Never> = .init()
    var fetchFailure: PassthroughSubject<Error, Never> = .init()

    init(userName: String) {
        let dummyFlinerEntities: [CollectionInfoEntity] = [
            .init(imageUrlString: "", profileImageUrlString: "", title: "사랑에 빠지기 10초 전", userName: "사용자 이름"),
            .init(imageUrlString: "", profileImageUrlString: "", title: "한번 보면 못 빠져나오는…", userName: "사용자 이름"),
            .init(imageUrlString: "", profileImageUrlString: "", title: "주말에 보기 좋은 영화", userName: "사용자 이름")
        ]

        let dummyRecentSavedItems: [RecentSavedContentItem] = [
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
                availableOn: [.wave, .tving, .netflix, .disneyPlus, .watcha],
                subscribedOn: [.tving, .wave, .netflix, .disneyPlus, .watcha]
            )
        ]

        let watchingEntities: [CollectionInfoEntity] = [
            .init(imageUrlString: "", profileImageUrlString: "", title: "요즘 빠진 스릴러만 모았어요", userName: "키키"),
            .init(imageUrlString: "", profileImageUrlString: "", title: "주말에 보기 좋은 힐링 영화", userName: "소은")
        ]

        let watchingRows: [HomeRow] = watchingEntities.isEmpty
        ? [
            .header(style: .normal, title: "아직 읽어본 컬렉션이 없어요", subtitle: "천천히 둘러보며 끌리는 취향을 발견해보세요"),
            .ctaButton(title: "취향발견하러가기")
        ]
        : [
            .header(style: .more, title: "눈여겨보고 있는 컬렉션", subtitle: "\(userName)님이 최근 살펴본 컬렉션이에요"),
            .fliner(items: watchingEntities)
        ]

        self.sections = .init([
            .init(rows: [.greeting(userName: userName)]),
            .init(rows: [
                .header(style: .normal, title: "Fliner의 추천 컬렉션을 만나보세요", subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"),
                .fliner(items: dummyFlinerEntities)
            ]),
            .init(rows: [
                .header(style: .normal, title: "최근 저장한 콘텐츠", subtitle: "현재 구독 중인 OTT에서 볼 수 있는 작품들이에요"),
                .recentSaved(items: dummyRecentSavedItems)
            ]),
            .init(rows: watchingRows)
        ])
    }

    func fetchRecommendedCollections() {
        // TabBar 호환용: 기본은 no-op
        fetchSuccess.send(())
    }
}
