//
//  OTTPlatformRowView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class OTTPlatformRowView: BaseView {

    // MARK: - Public Event

    var onTapOpen: (() -> Void)?

    // MARK: - UI

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    private let openButton = BasicButton(
        title: "바로 보러가기",
        titleStyle: .body2_m_14
    )


    // MARK: - Public API

    func configure(platform: OTTPlatform) {
        iconImageView.image = platform.icon
        titleLabel.attributedText = .pretendard(.body1_sb_16, text: platform.title , color: .flintWhite)
    }

    // MARK: - BaseView

    override func setUI() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(openButton)

        setAction()
    }

    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()

        }

        openButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(98)
            $0.height.equalTo(32)
        }
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    // MARK: - Action

    private func setAction() {
        openButton.addTarget(self, action: #selector(didTapOpen), for: .touchUpInside)
    }

    @objc private func didTapOpen() {
        onTapOpen?()
    }
}
