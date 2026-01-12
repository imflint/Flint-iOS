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
        $0.layer.cornerRadius = 18
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.font = .pretendard(.body1_sb_16)
        $0.numberOfLines = 1
    }

    private let openButton = BasicButton(title: "바로 보러가기")

    // MARK: - Public API

    func configure(platform: OTTPlatform) {
        iconImageView.image = platform.icon
        titleLabel.text = platform.title
        titleLabel.font = .pretendard(.body1_sb_16)
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
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(36)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(openButton.snp.leading).offset(-12)
        }

        openButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
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
