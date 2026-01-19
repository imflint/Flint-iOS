//
//  CollectionIntroduceTableViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit
import Then

public class CollectionIntroduceTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    public var reloadForNewHeight: (() -> Void)?
    
    // MARK: - Component
    
    public let headerLabel = UILabel().then {
        $0.textColor = .flintWhite
        let fullText = "컬렉션 소개 (선택)"
        let grayText = "(선택)"
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString.pretendard(.head3_m_18, text: "컬렉션 소개 (선택)"))
        attributedText.addAttribute(
            .foregroundColor,
            value: UIColor.flintGray300,
            range: (fullText as NSString).range(of: grayText)
        )
        $0.attributedText = attributedText
    }
    
    public let textView = FlintTextView(placeholder: "컬렉션의 주제를 작성해주세요.", maxLength: 200)
    
    public let textViewLengthLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.textAlignment = .right
    }
    
    // MARK: - Basic
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textView.onLengthChanged = { [weak self] textLength, maxLength in
            self?.textViewLengthLabel.attributedText = .pretendard(.caption1_m_12, text: "\(textLength)/\(maxLength)")
            self?.reloadForNewHeight?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    public override func setStyle() {
        contentView.backgroundColor = .flintBackground
        textViewLengthLabel.attributedText = .pretendard(.caption1_m_12, text: "\(0)/\(200)")
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(
            headerLabel,
            textView,
            textViewLengthLabel,
        )
    }
    
    public override func setLayout() {
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(104)
        }
        
        textViewLengthLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}
