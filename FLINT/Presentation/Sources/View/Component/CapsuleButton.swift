//
//  CapsuleButton.swift
//  Flint
//
//  Created by 김호성 on 2026.01.04.
//

import UIKit

import SnapKit
import Then

public final class CapsuleButton: UIButton {
    
    // MARK: - Enum
    
    public enum Style {
        case colored
        case outlined
        case gradientColored
        case gradientOutlined
    }
    
    // MARK: - Property
    
    public var style: Style {
        didSet {
            apply()
        }
    }
    public var title: String? {
        didSet {
            apply()
        }
    }
    
    // MARK: - Component
    
    private lazy var coloredBackgroundView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .flintPrimary400
    }
    
    private lazy var outlinedBackgroundView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .flintGray800
        $0.layer.borderColor = UIColor.flintGray300.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var gradientColoredBackgroundView = FixedGradientView().then {
        $0.isHidden = true
        $0.colors = [.flintPrimary200, .flintPrimary400]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0, y: 0)
        $0.endPoint = .init(x: 0.25, y: 1)
    }
    
    private lazy var gradientOutlinedOutlineView = FixedGradientView().then {
        $0.isHidden = true
        $0.colors = [UIColor(hex: 0xAEAEAE), UIColor(hex: 0x666666)]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0, y: 0)
        $0.endPoint = .init(x: 0.3, y: 0.5)
    }
    
    private lazy var gradientOutlinedBackgroundView = FixedGradientView().then {
        $0.isHidden = true
        $0.colors = [.flintGray600, .flintGray700]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0, y: 0)
        $0.endPoint = .init(x: 0.3, y: 0.5)
        $0.layer.cornerRadius = bounds.height / 2
        
        gradientOutlinedOutlineView.addSubview($0)
        $0.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(1)
        }
    }
    
    // MARK: - Basic
    
    public init(style: Style, title: String? = nil) {
        self.style = style
        self.title = title
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.cornerRadius = bounds.height / 2
        configuration = config
        
        if style == .gradientOutlined {
            gradientOutlinedBackgroundView.layer.cornerRadius = bounds.height / 2
        }
    }
    
    // MARK: - Setup
    
    private func setUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.cornerRadius = bounds.height / 2
        configuration = config
        
        apply()
    }
    
    private func apply() {
        coloredBackgroundView.isHidden = true
        outlinedBackgroundView.isHidden = true
        gradientColoredBackgroundView.isHidden = true
        gradientOutlinedBackgroundView.isHidden = true
        
        switch style {
        case .colored:
            setColoredUI()
        case .outlined:
            setOutlinedUI()
        case .gradientColored:
            setGradientColoredUI()
        case .gradientOutlined:
            setGradientOutlinedUI()
        }
    }
    
    private func setColoredUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        coloredBackgroundView.isHidden = false
        config.background.customView = coloredBackgroundView
        config.attributedTitle = .pretendard(.body2_m_14, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
    
    private func setOutlinedUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        outlinedBackgroundView.isHidden = false
        config.background.customView = outlinedBackgroundView
        config.attributedTitle = .pretendard(.body2_m_14, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
    
    private func setGradientColoredUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        gradientColoredBackgroundView.isHidden = false
        config.background.customView = gradientColoredBackgroundView
        config.attributedTitle = .pretendard(.body1_m_16, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
    
    private func setGradientOutlinedUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        gradientOutlinedOutlineView.isHidden = false
        config.background.customView = gradientOutlinedOutlineView
        config.attributedTitle = .pretendard(.body1_sb_16, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
}
