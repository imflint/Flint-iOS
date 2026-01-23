//
//  CreateCollectionDescriptionInputCell.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

public final class CreateCollectionDescriptionInputCell: BaseTableViewCell {
    
    //MARK: - Event
    
    public var onChangeDescription: ((String) -> Void)?
    
    //MARK: - UI
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(.head3_m_18, text: "컬랙션 소개",color: .flintWhite)
    }
    
    private let selectionLabel = UILabel().then {
        $0.attributedText = .pretendard(.head3_m_18, text: "(선택)", color: .flintGray300)
    }
    
    private let descriptionTextView = FlintTextView(
        placeholder: "컬렉션의 소개를 작성해주세요",
        maxLength: 200
    ).then {
        $0.isScrollEnabled = false
        $0.returnKeyType = .default
    }
    
    private let countLabel = UILabel().then {
        $0.textAlignment = .right
        $0.attributedText = .pretendard(.caption1_m_12, text: "0/200", color: .flintWhite)
    }
    
    //MARK: - Setup
    
    public override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(titleLabel, selectionLabel, descriptionTextView, countLabel)
        
        descriptionTextView.onLengthChanged = { [weak self] current, max in
            self?.countLabel.attributedText =
                .pretendard(.caption1_m_12, text: "\(current)/\(max)", color: .flintWhite)
        }
        
        registerNotification()
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(selectionLabel.snp.leading).offset(-4)
        }
        
        selectionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(100)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    
    public override func prepare() {
        onChangeDescription = nil
        descriptionTextView.text = nil
        countLabel.attributedText = .pretendard(.caption1_m_12, text: "0/200", color: .flintWhite)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UITextView.textDidChangeNotification,
            object: descriptionTextView
        )
        
        registerNotification()
    }
    
    public func setText(_ text: String) {
        descriptionTextView.text = text
        descriptionTextView.delegate?.textViewDidChange?(descriptionTextView)
    }
}

//MARK: - Notification

private extension CreateCollectionDescriptionInputCell {
    
    func registerNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextViewDIdChange),
            name: UITextView.textDidChangeNotification,
            object: descriptionTextView
        )
    }
    
    @objc func handleTextViewDIdChange() {
        onChangeDescription?(descriptionTextView.text ?? "")
    }
}
