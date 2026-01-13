//
//  OTTLogoStripeView.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class OTTLogoStripeView: BaseView {

    // MARK: - overlay

    private enum Metric {
        static let size: CGFloat = 26
        //TODO: - 이거 겹치는거몇이지?
        static let overlap: CGFloat = 14
    }

    // MARK: - UI

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

    // MARK: - BaseView

    override func setUI() {
        isUserInteractionEnabled = false
        isHidden = true
    }

    override func setHierarchy() {
        addSubview(firstLogoImageView)
        addSubview(secondLogoImageView)
        addSubview(remainingBadgeView)
    }

    override func setLayout() {
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
            $0.size.equalTo(Metric.size)
        }

        snp.makeConstraints {
            $0.trailing.equalTo(remainingBadgeView.snp.trailing)
            $0.bottom.equalTo(firstLogoImageView.snp.bottom)
        }
    }

    // MARK: - Configure

    func configure(leading platforms: [CircleOTTPlatform], remainingCount: Int) {
        guard !platforms.isEmpty else {
            isHidden = true
            return
        }

        isHidden = false

        if let first = platforms.first {
            firstLogoImageView.image = first.smallLogoImage
            firstLogoImageView.isHidden = false
        } else {
            firstLogoImageView.image = nil
            firstLogoImageView.isHidden = true
        }

        if platforms.count >= 2 {
            secondLogoImageView.image = platforms[1].smallLogoImage
            secondLogoImageView.isHidden = false
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
}

// MARK: - Private

private final class RemainingCountBadgeView: BaseView {
    
    private enum Metric {
        static let size: CGFloat = 28
        static let inset = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    }
    
    private let label = UILabel().then {
        $0.textAlignment = .center
    }
    
    override func setUI() {
        backgroundColor = .flintGray500
        layer.masksToBounds = true
    }

    override func setHierarchy() {
        addSubview(label)
    }
    
    override func setLayout() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.inset)
        }

        snp.makeConstraints {
            $0.height.equalTo(Metric.size)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    func configure(count: Int) {
        let text = "+\(count)"
        label.attributedText = .pretendard(.body2_m_14, text: text, color: .flintWhite)
    }
}
