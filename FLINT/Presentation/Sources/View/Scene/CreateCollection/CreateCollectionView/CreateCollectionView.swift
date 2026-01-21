//
//  CreateCollectionView.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

public final class CreateCollectionView: BaseView {

    // MARK: - Event

    public var onTapComplete: (() -> Void)?

    // MARK: - UI

    public let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableView.automaticDimension
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }

    private var completeButton = FlintButton(style: .disable, title: "완료")
    private let footerContainerView = UIView()

    private let footerButtonHeight: CGFloat = 48
    private let footerBottomInset: CGFloat = 4
    private let footerSideInset: CGFloat = 16

    // MARK: - Setup

    public override func setUI() {
        super.setUI()
        backgroundColor = .flintBackground
        applyFooter(button: completeButton)
    }

    public override func setHierarchy() {
        addSubview(tableView)
    }

    public override func setLayout() {
        super.setLayout()

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Public

    public func setCompleteEnabled(_ enabled: Bool) {
        updateCompleteButton(enabled: enabled)
    }

    public func refreshFooterLayout() {
        guard tableView.tableFooterView === footerContainerView else { return }
        footerContainerView.frame.size.width = tableView.bounds.width
        tableView.tableFooterView = footerContainerView
    }

    // MARK: - Private

    private func updateCompleteButton(enabled: Bool) {
        let nextStyle: FlintButton.Style = enabled ? .able : .disable
        let nextTitle: String = "완료"

        let newButton = FlintButton(style: nextStyle, title: nextTitle)

        completeButton = newButton
        applyFooter(button: newButton)
    }

    private func applyFooter(button: FlintButton) {
        footerContainerView.subviews.forEach { $0.removeFromSuperview() }
        footerContainerView.backgroundColor = .clear

        footerContainerView.addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(footerSideInset)
            $0.height.equalTo(footerButtonHeight)
            $0.bottom.equalToSuperview().inset(footerBottomInset)
        }

        button.removeTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)

        let footerHeight = footerButtonHeight + footerBottomInset
        footerContainerView.frame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: footerHeight
        )

        tableView.tableFooterView = footerContainerView
    }

    @objc private func didTapComplete() {
        onTapComplete?()
    }
}
