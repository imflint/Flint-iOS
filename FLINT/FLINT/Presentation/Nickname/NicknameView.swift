//
//  NicknameView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

import SnapKit
import Then

final class NicknameView: BaseView {
    
    // MARK: - Component
    
    let profileImageSettingView = ProfileImageSettingView()
    
    // MARK: - Basic
    
    
    
    // MARK: - Setup
    
    override func setUI() {
        backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        addSubviews(profileImageSettingView)
    }
    
    override func setLayout() {
        profileImageSettingView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
        }
    }
    
}
