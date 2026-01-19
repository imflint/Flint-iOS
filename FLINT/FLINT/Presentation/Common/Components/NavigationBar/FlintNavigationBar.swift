//
//  FlintNavigationBar.swift
//  FLINT
//
//  Created by 진소은 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class FlintNavigationBar: BaseView {
    
    public var onTapLeft: (() -> Void)?
    public var onTapRight: (() -> Void)?
    
    private var leftButtonLeadingConstraint: Constraint?
    private var rightButtonTrailingConstraint: Constraint?
    
    private var leftButton = UIButton().then {
        $0.tintColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private var rightButton = UIButton().then {
        $0.tintColor = .white
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubviews(leftButton, titleLabel, rightButton)

        leftButton.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(165)
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    public func apply(_ config: NavigationBarConfig) {
        applyBackground(config.backgroundStyle)
        applyLeft(config.left)
        applyTitle(config.title)
        applyRight(config.right)
    }
    
    public func applyLeft(_ item: NavLeftItem) {
        leftButton.isHidden = false
        leftButton.setTitle(nil, for: .normal)
        leftButton.setImage(nil, for: .normal)
        
        leftButton.imageView?.contentMode = .scaleAspectFit
        
        switch item {
        case .back:
            leftButtonLeadingConstraint?.update(offset: 12)
            setPadding(button: leftButton, padding: 12, image: .icBack)
        case .logo:
            leftButtonLeadingConstraint?.update(offset: 0)
            setPadding(button: leftButton, padding: 0, image: .icFlintLogo)
        case .none:
            leftButtonLeadingConstraint?.update(inset: 0)
            leftButton.isHidden = true
        }
    }
    
    public func applyTitle(_ title: String?) {
        titleLabel.attributedText = .pretendard(.body1_m_16, text: title ?? "", alignment: .center)
        titleLabel.isHidden = (title == nil || title?.isEmpty == true)
    }
    
    public func applyRight(_ item: NavRightItem) {
        rightButton.isHidden = false
        rightButton.setTitle(nil, for: .normal)
        rightButton.setImage(nil, for: .normal)
        
        switch item {
        case .close:
            rightButton.setImage(UIImage(resource: .icCancel), for: .normal)
            setPadding(button: rightButton, padding: 12, image: .icCancel)
            
        case .text(let title, let color):
            rightButton.setAttributedTitle(.pretendard(.body1_b_16, text: title, color: color, alignment: .center), for: .normal)
            setPadding(button: rightButton, padding: 16, image: nil)
            
        case .none:
            rightButton.isHidden = true
        }
    }
    
    private func applyBackground(_ style: NavigationBarBackgroundStyle) {
        switch style {
        case .solid(let color):
            backgroundView.backgroundColor = color

        case .clear:
            backgroundView.backgroundColor = .clear
        }
    }
    
    public func setPadding(button: UIButton, padding: CGFloat, image: UIImage?) {
        var config = button.configuration ?? .plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        config.image = image
        button.configuration = config
    }
    
    @objc private func didTapLeft() { onTapLeft?() }
    @objc private func didTapRight() { onTapRight?() }
}
