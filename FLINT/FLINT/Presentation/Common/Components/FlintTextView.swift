//
//  FlintTextView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.13.
//

import UIKit

import SnapKit
import Then

final class FlintTextView: BaseView {
    
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
    
    private let textView = UITextView().then {
        $0.backgroundColor = .flintGray800
        $0.tintColor = .flintGray300
        $0.textColor = .flintWhite
        
        $0.font = .pretendard(.body1_m_16)
        $0.attributedText = .pretendard(.body1_m_16, text: "")
        
        $0.textContainer.lineFragmentPadding = 0
        $0.contentInset = .zero
        $0.textContainerInset = .init(top: 10, left: 12, bottom: 10, right: 12)
        $0.layer.cornerRadius = 8
        
        $0.spellCheckingType = .no
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
        $0.smartInsertDeleteType = .no
        if #available(iOS 17.0, *) {
            $0.inlinePredictionType = .no
        }
        
        $0.isScrollEnabled = false
    }
    
    // MARK: - Basic
     
    init(placeholder: String, maxLength: Int? = nil) {
        self.placeholder = placeholder
        self.maxLength = maxLength
        super.init(frame: .zero)
        
        placeholderLabel.attributedText = .pretendard(.body1_m_16, text: placeholder, color: .flintGray300)
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setUI() {
        textView.attributedText = .pretendard(.body1_m_16, text: "")
        setTypingAttributes()
    }
    
    override func setHierarchy() {
        addSubviews(textView, placeholderLabel)
    }
    
    override func setLayout() {
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Private Function
    
    private func setTypingAttributes() {
        textView.typingAttributes = NSAttributedString.pretendard(.body1_m_16, text: " ", color: .flintWhite).attributes(at: 0, effectiveRange: nil)
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
