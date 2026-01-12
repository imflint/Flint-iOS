//
//  CapsuleButton.swift
//  Flint
//
//  Created by 김호성 on 2026.01.04.
//

import UIKit

import SnapKit
import Then

final class CapsuleButton: UIButton {
    
    enum Style {
        case plain
        case outline
    }
    
    var style: Style
    var title: String?
    
    private lazy var plainGradientBackgroundView = FixedGradientView().then {
        $0.colors = [.flintPrimary200, .flintPrimary400]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0, y: 0)
        $0.endPoint = .init(x: 0.25, y: 1)
    }
    
    private lazy var outlineGradientOutlineView = FixedGradientView().then {
        $0.colors = [UIColor(hex: 0xAEAEAE), UIColor(hex: 0x666666)]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0, y: 0)
        $0.endPoint = .init(x: 0.3, y: 0.5)
    }
    
    private lazy var outlineGradientBackgroundView = FixedGradientView().then {
        Log.d("dd")
        $0.colors = [.flintGray600, .flintGray700]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0, y: 0)
        $0.endPoint = .init(x: 0.3, y: 0.5)
        $0.layer.cornerRadius = bounds.height / 2
        
        outlineGradientOutlineView.addSubview($0)
        $0.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(1)
        }
    }
    
    init(style: Style, title: String? = nil) {
        self.style = style
        self.title = title
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.cornerRadius = bounds.height / 2
        configuration = config
        
        if style == .outline {
            outlineGradientBackgroundView.layer.cornerRadius = bounds.height / 2
        }
    }
    
    private func setUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.cornerRadius = bounds.height / 2
        configuration = config
        
        applyStyle(style: style)
    }
    
    private func applyStyle(style: Style) {
        switch style {
        case .plain:
            setPlainUI()
        case .outline:
            setOutlineUI()
        }
    }
    
    private func setPlainUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        config.background.customView = plainGradientBackgroundView
        config.attributedTitle = .pretendard(.body1_m_16, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
    
    private func setOutlineUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        config.background.customView = outlineGradientOutlineView
        config.attributedTitle = .pretendard(.body1_sb_16, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
}
