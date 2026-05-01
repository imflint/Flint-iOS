//
//  FlinerRecommendCardCell.swift
//  Presentation
//
//  Created by 소은 on 4/28/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

import Domain

public final class FlinerRecommendCardCell: BaseCollectionViewCell {
    
    // MARK: - UI Component
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let imageBottomGradientView = GradientView().then {
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    private let bottomGradientView = GradientView().then {
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.clipsToBounds = true
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    private let pillView = PillView()
    
    private let avatarImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
    }
    
    private let nicknameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.pretendard(.micro1_m_10)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.pretendard(.head3_sb_18)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.font = UIFont.pretendard(.caption1_r_12)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let avatarStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let textStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    // MARK: - Override
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func prepare() {
        thumbnailImageView.image = nil
        avatarImageView.image = nil
        nicknameLabel.text = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    // MARK: - Setup
    
    public override func setStyle() {
        layer.cornerRadius = 16
        clipsToBounds = true
        contentView.layer.cornerRadius = 16
        setActive(false)
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(
            thumbnailImageView,
            imageBottomGradientView,
            bottomGradientView,
            pillView
        )
        avatarStack.addArrangedSubviews(avatarImageView, nicknameLabel)
        pillView.addSubview(avatarStack)
        textStack.addArrangedSubviews(titleLabel, descriptionLabel)
        contentView.addSubview(textStack)
    }
    
    public override func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        imageBottomGradientView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(thumbnailImageView.snp.bottom)
            $0.height.equalTo(132)
        }
        
        bottomGradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(28)
        }
        
        avatarStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
        
        pillView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.leading.greaterThanOrEqualToSuperview().inset(34)
            $0.trailing.lessThanOrEqualToSuperview().inset(34)
        }
        
        textStack.snp.makeConstraints {
            $0.top.equalTo(pillView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.bottom.lessThanOrEqualToSuperview().inset(35)
        }
    }
    
    // MARK: - Configure
    
    public func configure(entity: CollectionEntity) {
        thumbnailImageView.kf.setImage(with: entity.thumbnailUrl)
        avatarImageView.kf.setImage(with: entity.user.profileImageUrl)
        nicknameLabel.text = String(entity.user.nickname.prefix(8))
        titleLabel.text = String(entity.title.prefix(15))
        descriptionLabel.text = entity.description
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Custom Method
    
    public func setActive(_ isActive: Bool) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        
        if isActive {
            contentView.backgroundColor = .flintPrimary900
            imageBottomGradientView.colors = [
                UIColor.flintPrimary900.withAlphaComponent(0),
                UIColor.flintPrimary900
            ]
            imageBottomGradientView.locations = [0, 1.0]
            bottomGradientView.colors = [
                UIColor.flintBlue.withAlphaComponent(0),
                UIColor.flintBlue.withAlphaComponent(0.2)
            ]
        } else {
            contentView.backgroundColor = .flintGray800
            imageBottomGradientView.colors = [
                UIColor.flintGray800.withAlphaComponent(0),
                UIColor.flintGray800
            ]
            bottomGradientView.colors = [
                UIColor.gradientGray.withAlphaComponent(0),
                UIColor.gradientGray.withAlphaComponent(0.2)
            ]
        }
        imageBottomGradientView.startPoint = CGPoint(x: 0.5, y: 0)
        imageBottomGradientView.endPoint = CGPoint(x: 0.5, y: 1)
        bottomGradientView.startPoint = CGPoint(x: 0.5, y: 0)
        bottomGradientView.endPoint = CGPoint(x: 0.5, y: 1)
        
        CATransaction.commit()
    }
}
