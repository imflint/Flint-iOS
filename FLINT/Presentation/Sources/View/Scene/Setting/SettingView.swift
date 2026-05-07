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
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.register(SettingMenuCell.self, forCellReuseIdentifier: SettingMenuCell.identifier)
        $0.register(SettingAccountCell.self, forCellReuseIdentifier: SettingAccountCell.identifier)
    }
    
    public let withdrawalButton = UIButton(type: .system).then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
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
            $0.height.equalTo(44)
        }
    }
}
