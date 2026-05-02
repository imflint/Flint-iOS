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
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 30
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .white
    }
    
    private let editProfileButton = FlintButton(style: .colorOutline, title: "프로필 수정")
    
    private let bottomSpacingView = UIView().then {
        $0.backgroundColor = .flintGray800
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        backgroundColor = .clear
        
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    public override func setHierarchy() {
        addSubviews(profileImageView, nicknameLabel, editProfileButton, bottomSpacingView)
    }
    
    public override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(60)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImageView)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(profileImageView)
            $0.width.equalTo(100)
            $0.height.equalTo(36)
        }
        
        bottomSpacingView.snp.makeConstraints {
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
                placeholder: UIImage(systemName: "person.circle.fill")?.withTintColor(.white.withAlphaComponent(0.3), renderingMode: .alwaysOriginal)
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
