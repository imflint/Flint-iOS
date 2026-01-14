//
//  FlintTextView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.13.
//

import UIKit

import SnapKit
import Then

final class FlintTextView: UITextView {
    
    // MARK: - Property
    
    var maxLength: Int?
    var onLengthChanged: ((_ textLength: Int, _ maxLength: Int) -> Void)?
    var placeholder: String {
        didSet {
            placeholderLabel.attributedText = .pretendard(.body1_m_16, text: placeholder, color: .flintGray300)
        }
    }
    
    // MARK: - Component
    
    private let placeholderLabel = UILabel().then {
        $0.textColor = .flintGray300
        $0.attributedText = .pretendard(.body1_m_16, text: "", color: .flintGray300)
    }
    
    // MARK: - Basic
     
    init(placeholder: String, maxLength: Int? = nil) {
        self.placeholder = placeholder
        self.maxLength = maxLength
        super.init(frame: .zero, textContainer: nil)
        
        setUI()
        setHierarchy()
        setLayout()
        
        placeholderLabel.attributedText = .pretendard(.body1_m_16, text: placeholder, color: .flintGray300)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setUI() {
        backgroundColor = .flintGray800
        tintColor = .flintGray300
        textColor = .flintWhite
        
        font = .pretendard(.body1_m_16)
        attributedText = .pretendard(.body1_m_16, text: "", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        typingAttributes = NSAttributedString.pretendard(.body1_m_16, text: " ", color: .flintWhite, lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority).attributes(at: 0, effectiveRange: nil)
        
        textContainer.lineFragmentPadding = 0
        contentInset = .zero
        textContainerInset = .init(top: 10, left: 12, bottom: 10, right: 12)
        layer.cornerRadius = 8
        
        spellCheckingType = .no
        autocapitalizationType = .none
        autocorrectionType = .no
        smartDashesType = .no
        smartQuotesType = .no
        smartInsertDeleteType = .no
        if #available(iOS 17.0, *) {
            inlinePredictionType = .no
        }
        
        isScrollEnabled = false
    }
    
    private func setHierarchy() {
        addSubview(placeholderLabel)
    }
    
    private func setLayout() {
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}

// MARK: - UITextViewDelegate

extension FlintTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let maxLength, let currentText = textView.text else { return }
        if currentText.count > maxLength {
            let newText = currentText.prefix(maxLength)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                textView.text = String(newText)
                placeholderLabel.isHidden = !textView.text.isEmpty
                onLengthChanged?(textView.text?.count ?? 0, maxLength)
            }
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
        onLengthChanged?(textView.text?.count ?? 0, maxLength)
    }
}
