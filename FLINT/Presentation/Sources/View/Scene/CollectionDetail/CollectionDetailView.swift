//
//  CollectionDetailView.swift
//  FLINT
//
//  Created by 진소은 on 1/21/26.
//

import UIKit

import SnapKit
import Then

public final class CollectionDetailView: BaseView {

    public let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }

    public override func setHierarchy() {
        backgroundColor = .flintBackground

        addSubview(tableView)
    }

    public override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
