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
    private let maxVisibleCount: Int = 10
    private let rowHeight: CGFloat = 56

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

    func configure(users: [SavedUserRowItem]) {
        self.users = users
        rebuild()

        scrollView.isScrollEnabled = users.count > maxVisibleCount
        scrollView.alwaysBounceVertical = users.count > maxVisibleCount

        let visibleCount = min(users.count, maxVisibleCount)
        let visibleHeight =
            CGFloat(visibleCount) * rowHeight
            + CGFloat(max(visibleCount - 1, 0)) * rowSpacing

        snp.updateConstraints {
            $0.height.equalTo(visibleHeight).priority(.required)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - BaseView

    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
