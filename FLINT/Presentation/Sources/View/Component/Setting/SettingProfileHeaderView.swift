//
//  SettingProfileHeaderView.swift
//  Presentation
//
//  Created by 소은 on 5/2/26.
//

import UIKit

import SnapKit
import Then
import Kingfisher

import Domain

public final class SettingProfileHeaderView: BaseView {
    
    // MARK: - Properties
    
    public var onEditProfileTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 28
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .pretendard(.body1_m_16)
        $0.textColor = DesignSystem.Color.white
    }
    
    private let editProfileButton = FlintButton(style: .smallColorOutline, title: "프로필 수정")
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .flintGray800
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        backgroundColor = .clear
        
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    public override func setHierarchy() {
        addSubviews(profileImageView, nicknameLabel, editProfileButton, separatorView)
    }
    
    public override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(12)
            $0.width.height.equalTo(56)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImageView)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(profileImageView)
            $0.width.greaterThanOrEqualTo(98)
            $0.height.equalTo(32)
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(12)
        }
    }
    
    // MARK: - Configuration
    
    
    public func configure(with profile: UserProfileEntity) {
        nicknameLabel.text = profile.nickname
        
        if let imageUrl = profile.profileImageUrl {
            profileImageView.kf.setImage(
                with: imageUrl,
                placeholder: DesignSystem.Image.Common.profileGray.withTintColor(.white.withAlphaComponent(0.3), renderingMode: .alwaysOriginal)
            )
        } else {
            
            profileImageView.image = UIImage(systemName: "person.circle.fill")?.withTintColor(.white.withAlphaComponent(0.3), renderingMode: .alwaysOriginal)
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapEditProfileButton() {
        onEditProfileTapped?()
    }
}
