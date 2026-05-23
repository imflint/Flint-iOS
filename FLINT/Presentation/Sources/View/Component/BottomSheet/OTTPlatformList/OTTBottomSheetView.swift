//
//  OTTBottomSheetView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

import Domain

public final class OTTBottomSheetView: BaseView {

    // MARK: - Public Event

    public var onTapDim: (() -> Void)?

    // MARK: - UI

    public let dimView = UIView().then {
        $0.backgroundColor = .flintOverlay
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
    }

    public let containerView = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 16 
        $0.clipsToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.head3_sb_18, text: "이 작품을 볼 수 있는 OTT", color: .flintWhite)
        $0.numberOfLines = 1
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }

    // MARK: - Layout

    private let rowHeight: CGFloat = 48
    private let rowSpacing: CGFloat = 8
    private let sheetTopInset: CGFloat = 24
    private let titleHeight: CGFloat = 24
    private let titleBottomSpacing: CGFloat = 16
    private let sheetBottomInset: CGFloat = 32

    private var platforms: [OTTPlatform] = []

    public var sheetHeight: CGFloat {
        let count = platforms.count
        let rowsHeight = CGFloat(count) * rowHeight
        let spacingsHeight = CGFloat(max(count - 1, 0)) * rowSpacing
        return sheetTopInset + titleHeight + titleBottomSpacing + rowsHeight + spacingsHeight + sheetBottomInset
    }

    // MARK: - Public API

    public func configure(platforms: [OTTPlatform]) {
        self.platforms = platforms
        rebuildRows()
    }

    public func setDimAlpha(_ alpha: CGFloat) {
        dimView.alpha = alpha
    }

    // MARK: - BaseView

    public override func setUI() {
        addSubview(dimView)
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)

        setAction()
    }

    public override func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(sheetHeight)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sheetTopInset)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(titleHeight)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(titleBottomSpacing)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(sheetBottomInset)
        }
    }

    // MARK: - Action

    private func setAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDim))
        dimView.addGestureRecognizer(tap)
    }

    @objc private func didTapDim() {
        onTapDim?()
    }

    // MARK: - Private

    private func rebuildRows() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        platforms.forEach { platform in
            let row = OTTPlatformRowView()
            row.configure(platform: platform)
            stackView.addArrangedSubview(row)
        }

        containerView.snp.updateConstraints {
            $0.height.equalTo(sheetHeight)
        }
        layoutIfNeeded()
    }
}
