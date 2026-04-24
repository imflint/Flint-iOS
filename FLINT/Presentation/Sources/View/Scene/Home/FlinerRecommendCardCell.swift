//
//  FlinerRecommendCardCell.swift
//  Presentation
//
//  Created by 소은 on 4/24/26.
//

import UIKit

import SnapKit
import Kingfisher
import Then


struct FlinerCardItem {
    let thumbnailURL: String?
    let curatorNickname: String?
    let curatorProfileURL: String?
    let title: String
    let description: String?
}

final class FlinerRecommendCardCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.backgroundColor = DesignSystem.Color.gray800
    }
    
    private let gradientView = GradientView().then {
        $0.colors = [.clear, UIColor.black.withAlphaComponent(0.85)]
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let avatarImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    private let nicknameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.pretendard(.micro1_m_10)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .flintGray50
        $0.font = UIFont.pretendard(.head3_sb_18)
        $0.numberOfLines = 1
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.font = UIFont.pretendard(.caption1_r_12)
        $0.numberOfLines = 2
    }
    
    private let avatarStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 6
    }
    
    private let textStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(item: FlinerCardItem) {
        if let urlStr = item.thumbnailURL, let url = URL(string: urlStr) {
            thumbnailImageView.kf.setImage(with: url)
        }
        if let urlStr = item.curatorProfileURL, let url = URL(string: urlStr) {
            avatarImageView.kf.setImage(with: url)
        }
        nicknameLabel.text = item.curatorNickname
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}

// MARK: - Layout

private extension FlinerRecommendCardCell {
    
    func setUI() {
        contentView.addSubviews(thumbnailImageView, gradientView)
        avatarStack.addArrangedSubviews(avatarImageView, nicknameLabel)
        textStack.addArrangedSubviews(avatarStack, titleLabel, descriptionLabel)
        gradientView.addSubview(textStack)
    }
    
    func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        
        textStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
