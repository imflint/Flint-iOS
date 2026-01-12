//
//  SavedUsersListView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class SavedUsersListView: BaseView {

    // MARK: - Layout

    private let rowSpacing: CGFloat = 8

    // MARK: - UI

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }

    // MARK: - Data

    private var users: [SavedUserRowItem] = []

    // MARK: - Public API

    func configure(users: [SavedUserRowItem]) {
        self.users = users
        rebuild()
    }

    // MARK: - BaseView

    override func setUI() {
        addSubview(stackView)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Private

    private func rebuild() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        users.forEach { user in
            let row = SavedUserRowView()
            row.configure(user: user)
            stackView.addArrangedSubview(row)
        }
    }
}
