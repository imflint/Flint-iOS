//
//  SettingView.swift
//  Presentation
//
//  Created by 소은 on 5/2/26.
//

import UIKit
import SnapKit
import Then

// MARK: - SettingView

public final class SettingView: BaseView {
    
    // MARK: - UI Components
    
    public let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(SettingMenuCell.self, forCellReuseIdentifier: SettingMenuCell.identifier)
        $0.register(SettingAccountCell.self, forCellReuseIdentifier: SettingAccountCell.identifier)
    }
    
    public let withdrawalButton = UIButton(type: .system).then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.flintGray300, for: .normal)
        $0.titleLabel?.font = .pretendard(.body2_m_14)
        $0.backgroundColor = .clear
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        backgroundColor = .flintBackground
    }
    
    public override func setHierarchy() {
        addSubviews(tableView, withdrawalButton)
    }
    
    public override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(withdrawalButton.snp.top).offset(-20)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
}
