//
//  Modal.swift
//  FLINT
//
//  Created by 진소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

import Domain

public class Modal: BaseView {
    
    // MARK: - Properties
    
    public var leftAction: ((UIAction) -> Void)
    public var rightAction: ((UIAction) -> Void)
    
    // MARK: - UI Components
    
    private let dimView = UIView().then {
        $0.backgroundColor = .flintOverlay
    }
    
    private let backgroundView = FixedGradientView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.colors = [.flintGray600, .flintGray700]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0, y: 0)
        $0.endPoint = .init(x: 0.4, y: 0.4)
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
    }
    
    private let captionLabel = UILabel().then {
        $0.textColor = .white
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
        $0.distribution = .fillEqually
    }
    
    private var leftButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitleColor(.flintBackground, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private var rightButton = UIButton().then {
        $0.backgroundColor = .flintPrimary400
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        dimView.alpha = 0
        backgroundView.alpha = 0
    }
    
    public override func setHierarchy() {
        addSubviews(dimView, backgroundView)
        backgroundView.addSubview(contentStackView)
        backgroundView.addSubview(buttonStackView)
        
        contentStackView.addArrangedSubviews(imageView, titleLabel, captionLabel)
        buttonStackView.addArrangedSubviews(leftButton, rightButton)
        
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDim)))
        dimView.isUserInteractionEnabled = true
    }
    
    public override func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(36)
            $0.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        rightButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(32)
            $0.bottom.equalTo(backgroundView.snp.bottom).offset(-20)
            $0.horizontalEdges.equalTo(backgroundView.snp.horizontalEdges).inset(16)
        }
    }
    
    // MARK: - Init
    
    public init(
        image: UIImage,
        title: String? = nil,
        caption: String,
        leftButtonTitle: String? = nil,
        rightButtonTitle: String,
        rightButtonColor: UIColor? = DesignSystem.Color.primary400,
        onLeft: ((UIAction) -> Void)? = nil,
        onRight: ((UIAction) -> Void)? = nil
    ) {
        self.leftAction = onLeft ?? { _ in
            Log.e("There is no leftAction")
        }
        self.rightAction = onRight ?? { _ in
            Log.e("There is no rightAction")
        }
        
        leftButton.addAction(UIAction(handler: leftAction), for: .touchUpInside)
        rightButton.addAction(UIAction(handler: rightAction), for: .touchUpInside)
        
        super.init(frame: .zero)
        
        imageView.image = image
        
        if let title {
            titleLabel.isHidden = false
            titleLabel.attributedText = NSAttributedString.pretendard(.head1_sb_22, text: title)
        } else {
            titleLabel.isHidden = true
            titleLabel.text = nil
        }
        
        captionLabel.attributedText = NSAttributedString.pretendard(.body1_m_16, text: caption)
        
        if let leftButtonTitle {
            leftButton.isHidden = false
            leftButton.setAttributedTitle(NSAttributedString.pretendard(.body1_sb_16, text: leftButtonTitle), for: .normal)
        } else {
            leftButton.isHidden = true
        }
        
        rightButton.setAttributedTitle(NSAttributedString.pretendard(.body1_sb_16, text: rightButtonTitle), for: .normal)
        rightButton.backgroundColor = rightButtonColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    public func show(in parent: UIView) {
        parent.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        parent.layoutIfNeeded()
        
        dimView.alpha = 0
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
            self.dimView.alpha = 1
            self.backgroundView.alpha = 1
        })
    }
    
    public func dismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
            self.dimView.alpha = 0
            self.backgroundView.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
            completion?()
        })
    }
    
     @objc private func didTapDim() { dismiss() }
}
