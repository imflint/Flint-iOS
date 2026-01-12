//
//  FlintButton.swift
//  Flint
//
//  Created by 김호성 on 2026.01.04.
//

import UIKit

import Then

final class FlintButton: UIButton {
    
    enum Style {
        case able
        case disable
        case outline
        case colorOutline
    }
    
    var style: Style
    var title: String?
    var image: UIImage?
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                applyStyle(style: style)
            } else {
                applyStyle(style: .disable)
            }
        }
    }
    
    init(style: Style, title: String? = nil, image: UIImage? = nil, equalTitleWidthWith widthGuideTitle: String? = nil) {
        self.style = style
        self.title = title
        self.image = image
        super.init(frame: .zero)
        
        setUI()
        
        if let widthGuideTitle {
            applyTitleMinWidth(widthGuideTitle)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        config.background.strokeWidth = 2
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.contentInsets = .zero
        config.background.cornerRadius = 8
        configuration = config
        
        applyStyle(style: style)
    }
    
    private func applyStyle(style: Style) {
        switch style {
        case .able:
            setAbleUI()
        case .disable:
            setDisableUI()
        case .outline:
            setOutlineUI()
        case .colorOutline:
            setColorOutlineUI()
        }
    }
    
    private func setAbleUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        let gradientView = FixedGradientView().then {
            $0.colors = [.flintPrimary200, .flintPrimary400]
            $0.locations = [0, 1]
            $0.startPoint = .init(x: 0, y: 0)
            $0.endPoint = .init(x: 0.25, y: 1)
        }
        config.background.customView = gradientView
        config.background.strokeColor = nil
        config.background.strokeWidth = 0
        config.image = image?.withTintColor(.flintWhite).resized(to: CGSize(width: 24, height: 24))
        config.attributedTitle = .pretendard(.body1_sb_16, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
    
    private func setDisableUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        config.background.customView = nil
        config.background.backgroundColor = .flintGray700
        config.background.strokeColor = nil
        config.background.strokeWidth = 0
        config.image = image?.withTintColor(.flintGray400).resized(to: CGSize(width: 24, height: 24))
        config.attributedTitle = .pretendard(.body1_sb_16, text: title ?? "", color: .flintGray400)
        
        configuration = config
    }
    
    private func setOutlineUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        config.background.customView = nil
        config.background.backgroundColor = .flintGray800
        config.background.strokeColor = .flintGray500
        config.background.strokeWidth = 2
        config.image = image?.withTintColor(.flintWhite).resized(to: CGSize(width: 24, height: 24))
        config.attributedTitle = .pretendard(.body1_sb_16, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
    
    private func setColorOutlineUI() {
        var config: UIButton.Configuration = configuration ?? .plain()
        
        config.background.customView = nil
        config.background.backgroundColor = .flintGray800
        config.background.strokeColor = .flintPrimary400
        config.background.strokeWidth = 2
        config.image = image?.withTintColor(.flintWhite).resized(to: CGSize(width: 24, height: 24))
        config.attributedTitle = .pretendard(.body1_sb_16, text: title ?? "", color: .flintWhite)
        
        configuration = config
    }
    
    private func applyTitleMinWidth(_ widthGuideTitle: String) {
        let titleMinWidth = NSAttributedString
            .pretendard(.body1_sb_16, text: widthGuideTitle)
            .boundingRect(
                with: CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: .zero
                ),
                options: [.usesFontLeading, .usesLineFragmentOrigin],
                context: nil
            ).width
        
        guard let attributedTitle = configuration?.attributedTitle else { return }
        let width = NSAttributedString(attributedTitle).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .zero),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            context: nil
        ).width
        
        let inset = (titleMinWidth - width) / 2
        
        var config: UIButton.Configuration = configuration ?? .plain()
        
        config.imagePadding = 4 + inset
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: inset / 2)
        
        configuration = config
    }
}
