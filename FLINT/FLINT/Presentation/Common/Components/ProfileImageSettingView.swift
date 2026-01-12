//
//  ProfileImageSettingView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

import SnapKit
import Then

final class ProfileImageSettingView: BaseView {
    
    // MARK: - Component
    
    let profileImageView = UIImageView().then {
        $0.image = .imgProfileGray
        $0.contentMode = .scaleAspectFill
    }
    
    let settingButton = UIButton().then {
        $0.setImage(.icProfileChange, for: .normal)
    }
    
    // MARK: - Basic
    
    
    
    // MARK: - Setup
    
    override func setUI() {
        
    }
    
    override func setHierarchy() {
        addSubviews(profileImageView, settingButton)
    }
    
    override func setLayout() {
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
