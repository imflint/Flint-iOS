//
//  ProfileView.swift
//  FLINT
//
//  Created by 진소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class ProfileView: UIView {

    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never

        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setHierarchy() {
        backgroundColor = .flintBackground
        addSubview(tableView)
    }

    private func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
