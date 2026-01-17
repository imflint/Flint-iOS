//
//  SelectedContentReasonExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/17/26.
//

import UIKit

import SnapKit
import Then

final class SelectedContentReasonExampleViewController: BaseViewController<UIView> {

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 320
        $0.contentInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        $0.keyboardDismissMode = .interactive
    }

    // MARK: - Data

    private var item = SelectedContentReasonTableViewCellItem(
        posterImage: UIImage(named: "poster_1"),
        title: "그 시절, 우리가 좋아했던 소녀",
        director: "구파도 감독",
        year: "2011",
        isSpoiler: false,
        reasonText: ""
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setTableView()
    }

    // MARK: - Setup

    override func setUI() {
        view.backgroundColor = .flintBackground
    }

    override func setHierarchy() {
        view.addSubview(tableView)
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SelectedContentReasonTableViewCell.self,
            forCellReuseIdentifier: "SelectedContentReasonTableViewCell"
        )
    }
}

// MARK: - UITableViewDataSource

extension SelectedContentReasonExampleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "SelectedContentReasonTableViewCell",
            for: indexPath
        ) as? SelectedContentReasonTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.configure(with: item)

        cell.onToggleSpoiler = { [weak self] isOn in
            guard let self else { return }
            self.item.isSpoiler = isOn
            // 필요하면 즉시 반영 UI 업데이트
            // self.tableView.reloadRows(at: [indexPath], with: .none)
        }

        cell.onChangeReasonText = { [weak self] text in
            guard let self else { return }
            self.item.reasonText = text
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SelectedContentReasonExampleViewController: UITableViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
