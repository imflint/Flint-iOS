//
//  RecentCollectionCell.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class RecentCollectionCell: BaseCollectionViewCell {

    static let reuseIdentifier = "RecentCollectionCell"

    // MARK: - UI

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let overlayContainerView = UIView()

    private let highGradientLayer = HighGradientView()
    private let bottomGradientLayer = BottomFadeGradientView()

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .flintGray50
        $0.numberOfLines = 1
    }

    private let userNameLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.numberOfLines = 1
    }

    // MARK: - Override Points

    override func setStyle() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    override func setHierarchy() {
        contentView.addSubview(imageView)

        contentView.addSubview(overlayContainerView)

        overlayContainerView.addSubview(highGradientLayer)
        overlayContainerView.addSubview(bottomGradientLayer)

        overlayContainerView.addSubview(profileImageView)
        overlayContainerView.addSubview(titleLabel)
        overlayContainerView.addSubview(userNameLabel)
    }

    override func setLayout() {
        imageView.snp.makeConstraints {
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
            $0.leading.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(32)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalTo(profileImageView.snp.centerY).offset(-1)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(profileImageView.snp.centerY).offset(1)
        }
    }

    override func prepare() {
        imageView.image = nil
        profileImageView.image = nil
        titleLabel.text = nil
        userNameLabel.text = nil
    }

    // MARK: - Configure

    func configure(with item: RecentCollectionItemViewData) {
        imageView.image = item.image
        profileImageView.image = item.profileImage

        titleLabel.text = item.title
        userNameLabel.text = item.userName
        
        titleLabel.font = UIFont.pretendard(.body2_m_14)
        userNameLabel.font = UIFont.pretendard(.caption1_r_12)
    }
}
