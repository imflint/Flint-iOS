//
//  ProfileImageSettingView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

import SnapKit
import Then

public final class ProfileImageSettingView: BaseView {
    
    // MARK: - Component
    
    public let profileImageView = UIImageView().then {
        $0.image = .imgProfileGray
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 60
    }
    
    public let settingButton = UIButton().then {
        $0.setImage(.icProfileChange, for: .normal)
        $0.isHidden = true
    }
    
    // MARK: - Basic
    
    
    
    // MARK: - Setup
    
    public override func setUI() {
        
    }
    
    public override func setHierarchy() {
        addSubviews(profileImageView, settingButton)
    }
    
    public override func setLayout() {
        snp.makeConstraints {
            $0.size.equalTo(128)
        }
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        settingButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
}
