//
//  SavedUsersListView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

public final class SavedUserListView: BaseView {

    private let rowSpacing: CGFloat = 8
    private let maxVisibleCount: CGFloat = 9
    private let rowHeight: CGFloat = 44

    private var maxHeightConstraint: Constraint?

    // MARK: - UI

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
    }

    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }

    // MARK: - Data

    private var users: [SavedUserRowItem] = []

    // MARK: - Public API

    public func configure(users: [SavedUserRowItem]) {
        self.users = users
        rebuild()
        
        let maxHeight =
            maxVisibleCount * rowHeight
            + (maxVisibleCount - 1) * rowSpacing

        maxHeightConstraint?.update(offset: maxHeight)

        scrollView.isScrollEnabled = users.count > Int(maxVisibleCount)
        scrollView.alwaysBounceVertical = users.count > Int(maxVisibleCount)

        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - BaseView

    public override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()

            maxHeightConstraint = $0.height.lessThanOrEqualTo(0).constraint
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }

    // MARK: - Private

    private func rebuild() {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        users.forEach { user in
            let row = SavedUserRowView()
            row.configure(user: user)

            row.snp.makeConstraints {
                $0.height.equalTo(rowHeight)
            }

            contentStackView.addArrangedSubview(row)
        }
    }
}
