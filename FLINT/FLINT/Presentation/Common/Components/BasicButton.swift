//
//  BasicButton.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.10.
//

import UIKit

final class BasicButton: UIButton {
    
    var title: String?
    var titleColor: UIColor
    var titleStyle: UIFont.PretendardStyle
    var buttonColor: UIColor
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                setAbleUI()
            } else {
                setDisableUI()
            }
        }
    }
    
    init(title: String? = nil, titleColor: UIColor = .flintWhite, titleStyle: UIFont.PretendardStyle = .body1_m_16, buttonColor: UIColor = .flintPrimary400) {
        self.title = title
        self.titleColor = titleColor
        self.titleStyle = titleStyle
        self.buttonColor = buttonColor
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.cornerRadius = 8
        configuration = config
        
        setAbleUI()
    }
    
    private func setAbleUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.backgroundColor = buttonColor
        config.attributedTitle = .pretendard(titleStyle, text: title ?? "", color: titleColor)
        configuration = config
    }
    
    private func setDisableUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.backgroundColor = .flintGray700
        config.attributedTitle = .pretendard(titleStyle, text: title ?? "", color: .flintGray400)
        configuration = config
    }
}
