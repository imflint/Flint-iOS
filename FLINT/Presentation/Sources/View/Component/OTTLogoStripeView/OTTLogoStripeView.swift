//
//  OTTLogoStripeView.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//


import UIKit

import SnapKit
import Then

import Entity

public final class OTTLogoStripeView: BaseView {

    private enum Metric {
        static let size: CGFloat = 26
        static let overlap: CGFloat = 16
    }

    private let firstLogoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Metric.size / 2
        $0.isHidden = true
    }

    private let secondLogoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Metric.size / 2
        $0.isHidden = true
    }

    private let remainingBadgeView = RemainingCountBadgeView().then {
        $0.isHidden = true
    }

    public override func setUI() {
        isUserInteractionEnabled = false
        isHidden = true
    }

    public override func setHierarchy() {
        addSubviews(firstLogoImageView, secondLogoImageView, remainingBadgeView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        applyShadowIfNeeded(to: remainingBadgeView)
        applyShadowIfNeeded(to: secondLogoImageView)
    }

    public override func setLayout() {
        firstLogoImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(Metric.size)
        }

        secondLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(firstLogoImageView.snp.leading).offset(Metric.overlap)
            $0.size.equalTo(Metric.size)
        }

        remainingBadgeView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(secondLogoImageView.snp.leading).offset(Metric.overlap)
        }

        snp.makeConstraints {
            $0.trailing.equalTo(remainingBadgeView.snp.trailing)
            $0.bottom.equalTo(firstLogoImageView.snp.bottom)
        }
    }

    
    public func configure(leadingServerNames names: [String], remainingCount: Int) {
        let platforms = names.compactMap { CircleOTTPlatform(serverName: $0) }

        // 고정 순서 유지
        let ordered = CircleOTTPlatform.order.filter { platforms.contains($0) }

        guard !ordered.isEmpty else {
            // asset 기반이라 cancelDownloadTask 필요 없음
            firstLogoImageView.image = nil
            secondLogoImageView.image = nil
            firstLogoImageView.isHidden = true
            secondLogoImageView.isHidden = true
            remainingBadgeView.isHidden = true
            isHidden = true
            return
        }

        isHidden = false

        if let first = ordered.first {
            firstLogoImageView.image = first.smallLogoImage
            firstLogoImageView.isHidden = (first.smallLogoImage == nil)
        } else {
            firstLogoImageView.image = nil
            firstLogoImageView.isHidden = true
        }

        if ordered.count >= 2 {
            let second = ordered[1]
            secondLogoImageView.image = second.smallLogoImage
            secondLogoImageView.isHidden = (second.smallLogoImage == nil)
        } else {
            secondLogoImageView.image = nil
            secondLogoImageView.isHidden = true
        }

        if remainingCount > 0 {
            remainingBadgeView.configure(count: remainingCount)
            remainingBadgeView.isHidden = false
        } else {
            remainingBadgeView.isHidden = true
        }
    }

    private func resetAndHide() {
        isHidden = true
        firstLogoImageView.kf.cancelDownloadTask()
        secondLogoImageView.kf.cancelDownloadTask()
        firstLogoImageView.image = nil
        secondLogoImageView.image = nil
        firstLogoImageView.isHidden = true
        secondLogoImageView.isHidden = true
        remainingBadgeView.isHidden = true
    }

    private func applyShadowIfNeeded(to view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: -4, height: 0)
        view.layer.shadowRadius = 6
        view.layer.shadowPath = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: view.bounds.height / 2
        ).cgPath
    }
}
