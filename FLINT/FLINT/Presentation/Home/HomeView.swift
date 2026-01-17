//
//  HomeView.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

final class HomeView: BaseView {

    // MARK: - UI

    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.estimatedRowHeight = 100
        $0.rowHeight = UITableView.automaticDimension
    }

    // MARK: - BaseView

    override func setUI() {
        backgroundColor = .flintBackground
        addSubview(tableView)
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
