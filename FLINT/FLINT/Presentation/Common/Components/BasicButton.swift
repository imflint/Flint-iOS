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
    var buttonColor: UIColor
    
    init(title: String? = nil, titleColor: UIColor = .flintWhite, buttonColor: UIColor = .flintPrimary400) {
        self.title = title
        self.titleColor = titleColor
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
        
        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            switch button.state {
            case .disabled:
                setDisableUI()
            default:
                setAbleUI()
            }
        }
    }
    
    private func setAbleUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.backgroundColor = .flintPrimary400
        config.setTitle(title ?? "", style: .body1_m_16, textColor: .flintWhite)
        configuration = config
    }
    
    private func setDisableUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.backgroundColor = .flintGray700
        config.setTitle(title ?? "", style: .body1_m_16, textColor: .flintGray400)
        configuration = config
    }
}
