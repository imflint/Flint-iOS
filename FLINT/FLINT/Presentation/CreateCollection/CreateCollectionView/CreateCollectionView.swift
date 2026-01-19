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
    
    private var currentTitle: String = ""
    private var isPublicSelected: Bool = false
    private var selectedWorkCount: Int = 0
    
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
    
    private var completeBUtton = FlintButton(style: .disable, title: "완료")
    

    //MARK: - Setup
    
    override func setUI() {
        super.setUI()
        backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        addSubviews(tableView, completeBUtton)
    }
    
    override func setLayout() {
        super.setLayout()
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        completeBUtton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    func setCompleteEnabled(_ enabled: Bool) {
        updateCompleteButton(enabled: enabled)
    }
    
    // MARK: - Private

    private func updateCompleteButton(enabled: Bool) {
        completeBUtton.removeFromSuperview()

        let newButton: FlintButton = enabled
        ? FlintButton(style: .able, title: "완료")
        : FlintButton(style: .disable, title: "시작하기")

        completeBUtton = newButton

        addSubview(completeBUtton)
        completeBUtton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(24)
        }

        tableView.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(completeBUtton.snp.top)
        }
    }


}
