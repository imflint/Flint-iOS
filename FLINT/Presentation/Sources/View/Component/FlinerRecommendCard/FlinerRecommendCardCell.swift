//
//  FlinerRecommendCardCell.swift
//  Presentation
//
//  Created by 소은 on 4/28/26.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class FlinerRecommendCardCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .flintGray800
    }
    
    private let gradientView = GradientView().then {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let pillView = UIView().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
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
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.font = UIFont.pretendard(.caption1_r_12)
        $0.numberOfLines = 2
        $0.textAlignment = .center
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setHierarchy()
        setLayout()
        setActive(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(item: FlinerCardItem) {
        thumbnailImageView.kf.setImage(with: item.thumbnailUrl)
        avatarImageView.kf.setImage(with: item.curatorProfileUrl)
        nicknameLabel.text = item.curatorNickname
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
    
    func setActive(_ isActive: Bool) {
        if isActive {
            gradientView.colors = [
                UIColor(hex: "1ABFF2").withAlphaComponent(0),
                UIColor(hex: "1ABFF2").withAlphaComponent(0.35)
            ]
            gradientView.startPoint = CGPoint(x: 0.5, y: 0)
            gradientView.endPoint = CGPoint(x: 0.5, y: 1)
        } else {
            gradientView.colors = [
                UIColor(hex: "2D4254").withAlphaComponent(0),
                UIColor(hex: "2D4254").withAlphaComponent(1.0)
            ]
            gradientView.startPoint = CGPoint(x: 0.5, y: 0)
            gradientView.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
}

// MARK: - Layout

private extension FlinerRecommendCardCell {
    
    func setHierarchy() {
        contentView.addSubviews(thumbnailImageView, gradientView)
        avatarStack.addArrangedSubviews(avatarImageView, nicknameLabel)
        pillView.addSubview(avatarStack)
        textStack.addArrangedSubviews(pillView, titleLabel, descriptionLabel)
        gradientView.addSubview(textStack)
    }
    
    func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(28)
        }
        
        avatarStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 12))
        }
        
        textStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
