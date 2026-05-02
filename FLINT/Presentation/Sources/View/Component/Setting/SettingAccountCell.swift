//
//  Setting.swift
//  Presentation
//
//  Created by 소은 on 5/2/26.
//

import UIKit

import SnapKit
import Then

// MARK: - SettingAccountCell

public final class SettingAccountCell: BaseTableViewCell {
    
    public static let identifier = "SettingAccountCell"
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "계정"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    private let emailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    private let kakaoIconImageView = UIImageView().then {
        $0.image = .imgKakaoLogo
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(titleLabel, emailLabel, kakaoIconImageView)
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview().offset(6)
        }
        
        
        kakaoIconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(emailLabel)
            $0.width.height.equalTo(16)
        }
        
        emailLabel.snp.makeConstraints {
            $0.trailing.equalTo(kakaoIconImageView.snp.leading).offset(-4)
            $0.centerY.equalToSuperview().offset(6)
        }
    }
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Configuration
    
    public func configure(with email: String) {
        emailLabel.text = email
    }
}
