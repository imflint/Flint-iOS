//
//  SearchTextField.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.08.
//

import UIKit

import SnapKit
import Then

final class FlintTextField: UITextField {
    
    // MARK: - Property
    
    var maxLength: Int?
    var onLengthChanged: ((_ textLength: Int, _ maxLength: Int) -> Void)?
    
    // MARK: - Component
    
    private let lengthLabel = UILabel().then {
        $0.textColor = .flintGray300
    }
    
    // MARK: - Basic
     
    init(placeholder: String, maxLength: Int? = nil, showLength: Bool = false) {
        self.maxLength = maxLength
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        
        attributedText = .pretendard(.body1_r_16, text: text ?? "")
        attributedPlaceholder = .pretendard(.body1_r_16, text: placeholder, color: .flintGray300)
        
        addAction(UIAction(handler: updateLengthLabel(_:)), for: .editingChanged)
        lengthLabel.isHidden = !showLength || maxLength == nil
        
        onLengthChanged?(text?.count ?? 0, maxLength ?? 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 12
        return padding
    }
    
    // MARK: - Setup
    
    private func setUI() {
        backgroundColor = .flintGray800
        tintColor = .flintGray300
        textColor = .flintWhite
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
        
        lengthLabel.attributedText = .pretendard(.body2_r_14, text: "\(text?.count ?? 0)/\(maxLength ?? 0)")
    }
    
    private func setLayout() {
        addLeftPadding(12)
        
        rightView = lengthLabel
        rightViewMode = .always
        
        snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    private func updateLengthLabel(_ action: UIAction) {
        guard let maxLength, let currentText = text else { return }
        if currentText.count > maxLength {
            let newText = currentText.prefix(maxLength)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                text = String(newText)
                onLengthChanged?(text?.count ?? 0, maxLength)
                lengthLabel.attributedText = .pretendard(.body2_r_14, text: "\(text?.count ?? 0)/\(maxLength)")
            }
        }
        onLengthChanged?(text?.count ?? 0, maxLength)
        lengthLabel.attributedText = .pretendard(.body2_r_14, text: "\(text?.count ?? 0)/\(maxLength)")
    }
}
