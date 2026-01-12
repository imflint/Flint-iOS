//
//  OTTBottomSheetView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class OTTBottomSheetView: BaseView {

    // MARK: - Public Event

    var onTapDim: (() -> Void)?
    var onTapOpen: ((OTTPlatform) -> Void)?

    // MARK: - UI

    let dimView = UIView().then {
        $0.backgroundColor = .flintOverlay
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
    }

    let containerView = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }

    private let grabberView = UIView().then {
        $0.backgroundColor = .flintGray500
        $0.layer.cornerRadius = 4
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }

    // MARK: - Layout Metric

    private let rowHeight: CGFloat = 48
    private let rowSpacing: CGFloat = 8
    private let sheetTopInset: CGFloat = 36
    private let sheetBottomInset: CGFloat = 12

    private var platforms: [OTTPlatform] = []

    var sheetHeight: CGFloat {
        let count = platforms.count
        let rowsHeight = CGFloat(count) * rowHeight
        let spacingsHeight = CGFloat(max(count - 1, 0)) * rowSpacing
        return sheetTopInset + rowsHeight + spacingsHeight + sheetBottomInset
    }

    // MARK: - Public API

    func configure(platforms: [OTTPlatform]) {
        self.platforms = platforms
        rebuildRows()
    }

    func setDimAlpha(_ alpha: CGFloat) {
        dimView.alpha = alpha
    }

    // MARK: - BaseView

    override func setUI() {
        addSubview(dimView)
        addSubview(containerView)

        containerView.addSubview(grabberView)
        containerView.addSubview(stackView)

        setAction()
    }

    override func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(sheetHeight)
        }

        grabberView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(52)
            $0.height.equalTo(4)
        }

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sheetTopInset)
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(24)
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
            row.onTapOpen = { [weak self] in
                self?.onTapOpen?(platform)
            }
            stackView.addArrangedSubview(row)
        }

        containerView.snp.updateConstraints {
            $0.height.equalTo(sheetHeight)
        }
        layoutIfNeeded()
    }
}
