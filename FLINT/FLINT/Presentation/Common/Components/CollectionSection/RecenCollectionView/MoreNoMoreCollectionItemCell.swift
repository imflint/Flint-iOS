//
//  RecentCollectionViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class MoreNoMoreCollectionItemCell: BaseCollectionViewCell {

    static let reuseIdentifier = "MoreNoMoreCollectionItemCell"

    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .flintGray200
    }

    private let overlayContainerView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }

    private let highGradientLayer = UpFadeGradientView()
    private let bottomGradientLayer = DownFadeGradientView()

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
        $0.backgroundColor = .flintGray600
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    private let userNameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    override func setStyle() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
    }

    override func setHierarchy() {
        contentView.addSubviews(posterImageView, overlayContainerView)
        overlayContainerView.addSubviews(highGradientLayer, bottomGradientLayer)
        overlayContainerView.addSubviews(profileImageView, titleLabel, userNameLabel)
    }

    override func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        overlayContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        highGradientLayer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomGradientLayer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
            $0.size.equalTo(28)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(profileImageView.snp.centerY).offset(-1)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(profileImageView.snp.centerY).offset(1)
        }
    }

    override func prepare() {
        posterImageView.image = nil
        profileImageView.image = nil
        titleLabel.attributedText = nil
        userNameLabel.attributedText = nil
    }

    func configure(with item: MoreNoMoreCollectionItem) {
        posterImageView.image = item.image
        profileImageView.image = item.profileImage

        titleLabel.attributedText = .pretendard(.body2_m_14, text: item.title, color: .flintGray50)
        userNameLabel.attributedText = .pretendard(.caption1_r_12, text: item.userName, color: .flintGray200)
    }
}
