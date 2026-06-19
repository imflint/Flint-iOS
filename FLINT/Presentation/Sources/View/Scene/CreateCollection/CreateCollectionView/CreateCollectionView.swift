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

    public var onChangeTitle: ((String) -> Void)?
    public var onTapComplete: (() -> Void)?

    private var currentTitle: String = ""
    private var isPublicSelected: Bool = false
    private var selectedWorkCount: Int = 0

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

    private var completeBUtton = FlintButton(style: .disable, title: "완료")

    private let footerContainerView = UIView()

    private let footerButtonHeight: CGFloat = 48
    private let footerBottomInset: CGFloat = 4
    private let footerSideInset: CGFloat = 16

    // MARK: - Setup

    public override func setUI() {
        super.setUI()
        backgroundColor = .flintBackground

        applyFooter(button: completeBUtton)
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
        let newButton: FlintButton = enabled
        ? FlintButton(style: .able, title: "완료")
        : FlintButton(style: .disable, title: "완료")

        completeBUtton = newButton
        applyFooter(button: newButton)
    }

    private func applyFooter(button: FlintButton) {
        footerContainerView.subviews.forEach { $0.removeFromSuperview() }
        footerContainerView.backgroundColor = .clear

        let copyrightLabel = UILabel().then {
            $0.attributedText = .pretendard(
                .caption1_r_12,
                text: "Flint에서 제공하는 영화 · 드라마를 포함한 모든 콘텐츠의 저작권은 각 권리자에게 있으며, 관련 법령에 따라 보호됩니다. 컬렉션 이용 시 저작권을 준수해 주세요.",
                color: .flintGray300
            )
            $0.textAlignment = .left
            $0.numberOfLines = 3
        }

        footerContainerView.addSubviews(copyrightLabel, button)

        copyrightLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(footerSideInset)
        }

        button.addAction(
            UIAction { [weak self] _ in
                self?.onTapComplete?()
            },
            for: .touchUpInside
        )

        button.snp.makeConstraints {
            $0.top.equalTo(copyrightLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(footerSideInset)
            $0.height.equalTo(footerButtonHeight)
            $0.bottom.equalToSuperview().inset(footerBottomInset)
        }

        let footerHeight = footerButtonHeight + footerBottomInset + 8 + 8
        footerContainerView.frame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: footerHeight + 40
        )

        tableView.tableFooterView = footerContainerView
    }
}
