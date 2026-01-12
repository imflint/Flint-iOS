//
//  SearchTextField.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.08.
//

import UIKit

import SnapKit
import Then

final class SearchTextField: UITextField {
    
    // MARK: - Property
    
    var searchAction: ((String?) -> Void)?
    
    // MARK: - Component
    
    private let actionButton = UIButton().then {
        $0.setImage(.icSearch, for: .normal)
    }
    
    // MARK: - Basic
     
    init(placeholder: String, searchAction: ((String?) -> Void)? = nil) {
        self.searchAction = searchAction
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setAction()
        
        attributedText = .pretendard(.body1_r_16, text: text ?? "")
        attributedPlaceholder = .pretendard(.body1_r_16, text: placeholder, color: .flintGray300)
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
        backgroundColor = .flintGray700
        tintColor = .flintGray300
        textColor = .flintWhite
        layer.cornerRadius = 22
        
        spellCheckingType = .no
        autocapitalizationType = .none
        autocorrectionType = .no
        smartDashesType = .no
        smartQuotesType = .no
        smartInsertDeleteType = .no
        if #available(iOS 17.0, *) {
            inlinePredictionType = .no
        }
    }
    
    private func setLayout() {
        addLeftPadding(16)
        
        rightView = actionButton
        rightViewMode = .always
        
        snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
    
    private func setAction() {
        actionButton.addAction(UIAction(handler: touchUpInsideActionButton(_:)), for: .touchUpInside)
        
        addAction(UIAction(handler: { [weak self] _ in
            self?.actionButton.setImage(.icCancel, for: .normal)
        }), for: .editingDidBegin)
        addAction(UIAction(handler: { [weak self] _ in
            self?.actionButton.setImage(.icSearch, for: .normal)
        }), for: .editingDidEnd)
    }
    
    // MARK: - Function
    
    private func touchUpInsideActionButton(_ action: UIAction) {
        if isFirstResponder {
            text = nil
        } else {
            searchAction?(text)
        }
    }
}
