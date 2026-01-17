//
//  RecentSavedContentExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class RecentSavedContentExampleViewController: UIViewController {

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Data

    private var recentItems: [RecentSavedContentItem] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setHierarchy()
        setLayout()

        seedDummy()
        tableView.reloadData()
    }

    // MARK: - Setup

    private func setUI() {
        view.backgroundColor = .flintBackground

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            RecentSavedContentTableViewCell.self,
            forCellReuseIdentifier: RecentSavedContentTableViewCell.reuseIdentifier
        )
    }

    private func setHierarchy() {
        view.addSubview(tableView)
    }

    private func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Private

    private func seedDummy() {
        recentItems = [
            RecentSavedContentItem(
                posterImageName: "poster_1",
                title: "더미 콘텐츠 1",
                year: 2024,
                availableOn: [.netflix, .tving, .watcha],
                subscribedOn: [.netflix, .watcha]
            ),
            RecentSavedContentItem(
                posterImageName: "poster_1",
                title: "더미 콘텐츠 2",
                year: 2023,
                availableOn: [.wave, .tving],
                subscribedOn: [.tving]
            ),
            RecentSavedContentItem(
                posterImageName: "poster_1",
                title: "더미 콘텐츠 3",
                year: 2022,
                availableOn: [.netflix, .wave, .disneyPlus, .tving],
                subscribedOn: [.netflix, .tving, .disneyPlus]
            ),
            RecentSavedContentItem(
                posterImageName: "poster_1",
                title: "더미 콘텐츠 4",
                year: 2021,
                availableOn: [.netflix, .wave, .tving],
                subscribedOn: [.netflix]
            ),
            RecentSavedContentItem(
                posterImageName: "poster_1",
                title: "더미 콘텐츠 5",
                year: 2020,
                availableOn: [.disneyPlus, .tving],
                subscribedOn: [.disneyPlus, .tving]
            )
        ]
    }
}

// MARK: - UITableViewDataSource

extension RecentSavedContentExampleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSavedContentTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? RecentSavedContentTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(items: recentItems)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RecentSavedContentExampleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180 + 14 + 18 + 8 + 15
    }
}
