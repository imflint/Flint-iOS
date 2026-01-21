//
//  CreateCollectionAddContentCell.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

public final class CreateCollectionAddContentCell: BaseTableViewCell {
    
    // MARK: - Event
    
    public var onTapAdd: (() -> Void)?
    
    // MARK: - UI
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = .pretendard(.head3_m_18, text: "작품 추가", color: .flintWhite)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = .pretendard(.body2_r_14, text: "작품을 2개 이상 추가해주세요.", color: .flintGray300)
    }
    
    private let countLabel = UILabel().then {
        $0.textAlignment = .right
        $0.attributedText = .pretendard(.caption1_m_12, text: "0/10", color: .flintWhite)
    }
    
    private let addButton = FlintButton(
        style: .colorOutline,
        title: "작품 추가하기",
        image: .icPlus
    )
    
    // MARK: - Setup
    
    public override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(titleLabel, subtitleLabel, countLabel, addButton)
        setAction()
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(countLabel.snp.leading).offset(-12)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(countLabel.snp.leading).offset(-12)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(subtitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(36)
            $0.height.equalTo(80)
        }
    }
    
    public override func prepare() {
        onTapAdd = nil
        //TODO: - countLabel은 외부에서 configure로 갱신할 예정
    }
}

// MARK: - Action

private extension CreateCollectionAddContentCell {
    
    func setAction() {
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    }
    
    @objc func didTapAdd() {
        onTapAdd?()
    }
}
