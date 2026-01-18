//
//  HomeView.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

final class HomeView: BaseView {
    
    // MARK: - UI
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    let floatingButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "img_fab"), for: .normal)
    }
    
    // MARK: - BaseView
    
    override func setUI() {
        backgroundColor = .flintBackground
        addSubviews(tableView, floatingButton)
        bringSubviewToFront(floatingButton)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.size.equalTo(48)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        floatingButton.layer.applyShadow(
            color: .black,
            alpha: 0.3,
            blur: 16,
            spread: 0,
            x: 0,
            y: 0,
            cornerRadius: 24
        )
    }
}
