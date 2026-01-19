//
//  CreateCollectionTitleInputCell.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class CreateCollectionTitleInputCell: BaseTableViewCell {
    
    // MARK: - Event
    
    var onChangeTitle: ((String) -> Void)?
    
    // MARK: - UI
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(.head3_m_18, text: "컬렉션 제목", color: .flintWhite)
    }
    
    private let titleTextView = FlintTextView(
        placeholder: "컬렉션 제목을 입력해주세요",
        maxLength: 20
        
    ).then {
        $0.isScrollEnabled = false
        $0.textContainer.maximumNumberOfLines = 2
        $0.textContainer.lineBreakMode = .byTruncatingTail
        $0.returnKeyType = .done
    }
    
    private let countLabel = UILabel().then {
        $0.attributedText = .pretendard(.caption1_m_12, text: "0/20", color: .flintWhite)
        $0.textAlignment = .right
    }
    
    // MARK: - Setup
    
    override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        contentView.addSubviews(titleLabel, titleTextView,countLabel)
        
        titleTextView.onLengthChanged = { [weak self] current, max in
            self?.countLabel.attributedText =
                .pretendard(.caption1_m_12, text: "\(current)/\(max)", color: .flintWhite)
        }
        
        registerNotification()
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    
    override func prepare() {
        onChangeTitle = nil
        titleTextView.text = nil
        countLabel.attributedText = .pretendard(.caption1_m_12, text: "0/20", color: .flintWhite)
        NotificationCenter.default.removeObserver(
            self,
            name: UITextView.textDidChangeNotification,
            object: titleTextView
        )
        
        registerNotification()
    }
}

// MARK: - Notification

private extension CreateCollectionTitleInputCell {
    
    func registerNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextViewDidChange),
            name: UITextView.textDidChangeNotification,
            object: titleTextView
        )
    }
    
    @objc func handleTextViewDidChange() {
        onChangeTitle?(titleTextView.text ?? "")
    }
}
