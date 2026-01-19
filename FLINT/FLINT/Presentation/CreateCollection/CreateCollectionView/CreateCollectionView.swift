//
//  CreateCollectionView.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class CreateCollectionView: BaseView {
    
    var onChangeTitle: ((String) -> Void)?
    
    //MARK: - UI Component

    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableView.automaticDimension
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0) 
    }

    //MARK: - Setup
    
    override func setUI() {
        super.setUI()
        backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        addSubviews(tableView)
    }
    
    override func setLayout() {
        super.setLayout()
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
