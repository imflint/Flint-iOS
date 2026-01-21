//
//  CollectionDetailViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/21/26.
//

import UIKit

import SnapKit

final class CollectionDetailViewController: BaseViewController<CollectionDetailView> {

    private enum Row {
        case header
        case description
        case film(Int)
        case saveUsers
    }

    private let filmCount: Int = 3

    private lazy var rows: [Row] = {
        var result: [Row] = [.header, .description]
        result += (0..<filmCount).map { .film($0) }
        result += [.saveUsers]
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .flintBackground
        setupTableView()
        setNavigationBar(.init(left: .back, backgroundStyle: .clear))
    }

    override func setBaseLayout() {
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(statusBarBackgroundView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        rootView.snp.makeConstraints {
            $0.top.equalTo(statusBarBackgroundView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        let tableView = rootView.tableView

        tableView.backgroundColor = .flintBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag

        tableView.insetsContentViewsToSafeArea = false

        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(CollectionDetailHeaderTableViewCell.self,
                           forCellReuseIdentifier: CollectionDetailHeaderTableViewCell.reuseIdentifier)
        tableView.register(CollectionDetailDescriptionTableViewCell.self,
                           forCellReuseIdentifier: CollectionDetailDescriptionTableViewCell.reuseIdentifier)
        tableView.register(CollectionDetailFilmTableViewCell.self,
                           forCellReuseIdentifier: CollectionDetailFilmTableViewCell.reuseIdentifier)
        tableView.register(CollectionSaveUserTableViewCell.self,
                           forCellReuseIdentifier: CollectionSaveUserTableViewCell.reuseIdentifier)

        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource

extension CollectionDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch rows[indexPath.row] {

        case .header:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailHeaderTableViewCell

            cell.selectionStyle = .none
            cell.configure(title: "한 번 보면 못 빠져나오는\n사랑 이야기", isSaved: false)
            cell.onTapSave = { isSaved in
                print("Header save tapped:", isSaved)
            }
            return cell

        case .description:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailDescriptionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailDescriptionTableViewCell

            cell.selectionStyle = .none
            cell.configure(
                author: "키카",
                isVerified: true,
                dateText: "2026. 01. 07.",
                description: "시간이 흘러도 빛이 바래지 않는,\n사랑의 미묘한 온도를 담은 제 최애 영화 모음집입니다"
            )
            return cell

        case .film(let idx):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionDetailFilmTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionDetailFilmTableViewCell

            cell.selectionStyle = .none
            cell.configureSpoiler(isSpoiler: true)
            cell.onTapRevealSpoiler = { [weak cell] in
                cell?.configureSpoiler(isSpoiler: false)
            }

            return cell

        case .saveUsers:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionSaveUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! CollectionSaveUserTableViewCell

            cell.selectionStyle = .none

            let dummyImages: [UIImage] = [
                UIImage(resource: .imgProfileGray),
                UIImage(resource: .imgBackgroundGradiantLarge),
                UIImage(resource: .imgProfileGray),
                UIImage(resource: .imgBackgroundGradiantMiddle),
                UIImage(resource: .imgProfileGray),
                UIImage(resource: .imgBackgroundGradiantLarge)
            ]

            cell.configure(title: "이 컬렉션을 저장한 사람들", images: dummyImages)
            cell.onTapMore = { print("Tap more (save users)") }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension CollectionDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
