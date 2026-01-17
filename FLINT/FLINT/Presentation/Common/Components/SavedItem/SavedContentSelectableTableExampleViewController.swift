//
//  SavedContentSelectableTableExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/17/26.
//

import UIKit

import SnapKit
import Then

final class SavedContentSelectableTableExampleViewController: UIViewController {

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Data

    private struct Item {
        let id: UUID
        let model: SavedContentItemViewModel
    }

    private var items: [Item] = []
    private var selectedIds: Set<UUID> = []

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flintBackground

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.edges.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            SavedContentSelectableTableViewCell.self,
            forCellReuseIdentifier: SavedContentSelectableTableViewCell.reuseIdentifier
        )

        items = makeDummyItems()
    }
}

// MARK: - UITableViewDataSource

extension SavedContentSelectableTableExampleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SavedContentSelectableTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? SavedContentSelectableTableViewCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        let isSelected = selectedIds.contains(item.id)

        cell.configure(model: item.model, isSelected: isSelected)

        cell.onTapCheckbox = { [weak self, weak tableView] newSelected in
            guard let self else { return }

            if newSelected {
                self.selectedIds.insert(item.id)
            } else {
                self.selectedIds.remove(item.id)
            }
            tableView?.reloadRows(at: [indexPath], with: .none)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SavedContentSelectableTableExampleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 150
    }
}

// MARK: - Dummy

private extension SavedContentSelectableTableExampleViewController {

    private func makeDummyItems() -> [Item] {
        let dummyModels: [SavedContentItemViewModel] = [
            SavedContentItemViewModel(
                posterImage: UIImage(named: "poster_1"),
                title: "은하수를 여행하는 히치하이커를 위한 안내서",
                director: "가스 제닝스",
                year: "2005"
            )
        ]

        return dummyModels.map { Item(id: UUID(), model: $0) }
    }
}
