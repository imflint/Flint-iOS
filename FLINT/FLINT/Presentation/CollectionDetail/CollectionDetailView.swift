//
//  CollectionDetailView.swift
//  FLINT
//
//  Created by 진소은 on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class CollectionDetailView: BaseView {

    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }

    override func setHierarchy() {
        backgroundColor = .flintBackground

        addSubview(tableView)
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
