//
//  CollectionTitleTableViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit
import Then

public class CollectionTitleTableViewCell: BaseTableViewCell {
    
    // MARK: - Component
    
    public let headerLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.attributedText = .pretendard(.head3_m_18, text: "컬렉션 제목")
    }
    
    public let textField = FlintTextField(placeholder: "컬렉션 제목을 입력해주세요", maxLength: 20)
    
    public let textFieldLengthLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.textAlignment = .right
    }
    
    // MARK: - Basic
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .flintBackground
        textFieldLengthLabel.attributedText = .pretendard(.caption1_m_12, text: "\(0)/\(20)")
        textField.onLengthChanged = { [weak self] textLength, maxLength in
            self?.textFieldLengthLabel.attributedText = .pretendard(.caption1_m_12, text: "\(textLength)/\(maxLength)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(
            headerLabel,
            textField,
            textFieldLengthLabel,
        )
    }
    
    public override func setLayout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textFieldLengthLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}
