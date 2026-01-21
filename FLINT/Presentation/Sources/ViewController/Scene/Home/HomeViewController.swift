//
//  HomeViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit
import Combine

import View
import ViewModel
import Domain

public final class HomeViewController: BaseViewController<HomeView> {

    private let viewModel: HomeViewModelType
    private var sections: [HomeViewModel.SectionModel] = []

    // MARK: - Init

    public init(viewModel: HomeViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bindViewModel()
        bindActions()

        viewModel.fetchRecommendedCollections()
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

    private func bindViewModel() {
        viewModel.sections
            .receive(on: RunLoop.main)
            .sink { [weak self] sections in
                self?.sections = sections
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)
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

    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let row = sections[indexPath.section].rows[indexPath.row]

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

            cell.configure(style: style, title: title, subtitle: subtitle)

            if style == .more {
                cell.onTapMore = { [weak self] in
                    let vc = CollectionFolderListViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                cell.onTapMore = nil
            }

            return cell

        case .fliner(let items):
             print("HomeVC fliner row items:", items.count)

            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = sections[indexPath.section].rows[indexPath.row]
        switch row {
        case .fliner:
            return 180 
        default:
            return UITableView.automaticDimension
        }
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = sections[indexPath.section].rows[indexPath.row]
        switch row {
        case .fliner:
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
