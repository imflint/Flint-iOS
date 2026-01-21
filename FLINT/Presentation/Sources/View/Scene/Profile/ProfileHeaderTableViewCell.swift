//
//  ProfileHeaderTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

public final class ProfileHeaderTableViewCell: BaseTableViewCell {
    
    // MARK: - Component
    
    private let profilebackgroundImageView = UIImageView().then {
        $0.image = UIImage(resource: .imgBackgroundGradiantMiddle)
        $0.contentMode = .scaleToFill
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(resource: .imgProfileGray)
    }
    
    private let gradientView = GradientView().then {
        $0.colors = [.flintSecondary600, .clear]
        $0.locations = [0.0, 1.0]
        $0.startPoint = CGPoint(x: 0.5, y: 0.0)
        $0.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    private let nameStack = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .white
        $0.attributedText = .pretendard(.display2_m_28, text: "쏘나기")
    }
    
    private let verificationBadge = UIImageView().then {
        $0.image = UIImage(resource: .icQuilified)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        verificationBadge.isHidden = false
    }
    
    public override func setHierarchy() {
        contentView.backgroundColor = .flintBackground
        contentView.addSubviews(profilebackgroundImageView, gradientView, profileImageView, nameStack)
        nameStack.addArrangedSubviews(nameLabel, verificationBadge)
    }
    
    public override func setLayout() {
        profilebackgroundImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(230)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.bottom.equalTo(profilebackgroundImageView.snp.bottom).offset(34)
            $0.size.equalTo(128)
        }
        
        gradientView.snp.makeConstraints {
            $0.top.equalTo(profilebackgroundImageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        nameStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.height.equalTo(42)
            
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    public func configure(name: String, isVerified: Bool) {
        nameLabel.attributedText = .pretendard(.display2_m_28, text: name)
        verificationBadge.isHidden = !isVerified
    }
}
