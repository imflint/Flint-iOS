//
//  HomeViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit

final class HomeViewController: BaseViewController<HomeView> {
    
    enum MainTableViewSection: Int, CaseIterable {
        case greeting
        case flinerRecommend
        case recentSaved
        case watchingCollection
    }


    private let userName: String = "얀비"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
    }

    // MARK: - Override Points

    override func setUI() {
        view.backgroundColor = .flintBackground
        
        setNavigationBar(
               .init(
                   left: .logo,
                   right: .none,
                   backgroundStyle: .solid(.flintBackground)
               )
           )
        
        statusBarBackgroundView.isHidden = true
    }

    // MARK: - Private

    private func setTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }

    private func registerCells() {
        rootView.tableView.register(
            HomeGreetingTableViewCell.self,
            forCellReuseIdentifier: HomeGreetingTableViewCell.reuseIdentifier
        )

        // 이미 만들어둔 셀들 등록
        // rootView.tableView.register(
        //     FlinerRecommendTableViewCell.self,
        //     forCellReuseIdentifier: FlinerRecommendTableViewCell.reuseIdentifier
        // )
        // rootView.tableView.register(
        //     RecentSavedContentTableViewCell.self,
        //     forCellReuseIdentifier: RecentSavedContentTableViewCell.reuseIdentifier
        // )
        // rootView.tableView.register(
        //     WatchingCollectionTableViewCell.self,
        //     forCellReuseIdentifier: WatchingCollectionTableViewCell.reuseIdentifier
        // )
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        MainTableViewSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = MainTableViewSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch section {

        case .greeting:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeGreetingTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? HomeGreetingTableViewCell else { return UITableViewCell() }

            cell.configure(userName: userName)
            return cell

        case .flinerRecommend:
            return dummyCell(title: "Fliner 추천 섹션 셀 연결 필요")

        case .recentSaved:
            return dummyCell(title: "최근 저장 섹션 셀 연결 필요")

        case .watchingCollection:
            return dummyCell(title: "눈여겨보는 컬렉션 섹션 셀 연결 필요")
        }
    }

    private func dummyCell(title: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.text = title
        cell.textLabel?.textColor = .flintGray200
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
