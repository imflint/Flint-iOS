//
//  RecentCollectionCell.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class MoreNoMoreCollectionViewCell: BaseCollectionViewCell {

    static let reuseIdentifier = "RecentCollectionCell"

    // MARK: - UI

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let overlayContainerView = UIView()

    private let highGradientLayer = UpFadeGradientView()
    private let bottomGradientLayer = DownFadeGradientView()

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .flintGray50
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    private let userNameLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.numberOfLines = 1
    }

    // MARK: - override

    override func setStyle() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    override func setHierarchy() {
        contentView.addSubviews(imageView, overlayContainerView)

        overlayContainerView.addSubviews(highGradientLayer, bottomGradientLayer)

        overlayContainerView.addSubviews(profileImageView, titleLabel, userNameLabel)
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
            $0.leading.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(14)
            $0.size.equalTo(28)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalTo(profileImageView.snp.centerY).offset(-1)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(profileImageView.snp.centerY).offset(1)
            $0.bottom.equalToSuperview().inset(11)
        }
    }

    override func prepare() {
        imageView.image = nil
        profileImageView.image = nil
        titleLabel.text = nil
        userNameLabel.text = nil
    }

    // MARK: - Configure
    func configure(with item: MoreNoMoreCollectionView) {
        imageView.image = item.image
        profileImageView.image = item.profileImage

        let title = truncated(item.title, limit: 15)

        titleLabel.attributedText = .pretendard(
            .body2_m_14,
            text: title,
            color: .flintGray50
        )

        userNameLabel.attributedText = .pretendard(
            .caption1_r_12,
            text: item.userName,
            color: .flintGray200
        )
    }
    
    private func truncated(_ text: String, limit: Int) -> String {
        guard text.count > limit else { return text }
        let prefix = text.prefix(limit)
        return "\(prefix)…"
    }


}
