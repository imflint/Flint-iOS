//
//  BasicButton.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.10.
//

import UIKit

public final class BasicButton: UIButton {
    
    public var title: String?
    public var titleColor: UIColor
    public var titleStyle: UIFont.PretendardStyle
    public var buttonColor: UIColor
    
    public override var isEnabled: Bool {
        didSet {
            if isEnabled {
                setAbleUI()
            } else {
                setDisableUI()
            }
        }
    }
    
    public init(title: String? = nil, titleColor: UIColor = DesignSystem.Color.white, titleStyle: UIFont.PretendardStyle = .body1_m_16, buttonColor: UIColor = DesignSystem.Color.primary400) {
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
