//
//  ActionToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 30/06/2021.
//

import UIKit

import SnapKit
import Then

public final class ActionToastView: BaseView, ToastView {
    
    // MARK: - Property
    
    private var toast: Toast?
    private var customConstraints: ((_ make: ConstraintMaker) -> Void)?
    
    // MARK: - Component
    
    private var mainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private var infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .equalSpacing
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .flintWhite
    }
    
    private var actionButton = UIButton().then {
        var config: UIButton.Configuration = $0.configuration ?? .plain()
        config.image = .icMore.withTintColor(.flintGray200).resized(to: CGSize(width: 16, height: 16))
        config.imagePadding = 0
        config.imagePlacement = .trailing
        config.baseForegroundColor = .flintGray200
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        $0.configuration = config
    }
    
    // MARK: - Basic
    
    public init(image: UIImage, title: String, actionTitle: String, action: @escaping (UIAction) -> Void, customConstraints: ((_ make: ConstraintMaker) -> Void)? = nil) {
        super.init(frame: .zero)
        
        imageView.image = image
        titleLabel.attributedText = .pretendard(.body1_sb_16, text: title)
        actionButton.configuration?.attributedTitle = .pretendard(.body2_r_14, text: actionTitle)
        actionButton.addAction(UIAction(handler: action), for: .touchUpInside)
        self.customConstraints = customConstraints
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromSuperview() {
      super.removeFromSuperview()
      self.toast = nil
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews(imageView, infoStackView)
        infoStackView.addArrangedSubviews(titleLabel, actionButton)
    }
    
    public override func setLayout() {
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(48)
        }
    }
    
    // MARK: - Function
    
    public func createView(for toast: Toast) {
        self.toast = toast
        snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(11)
            $0.centerX.equalToSuperview()
        }
        snp.makeConstraints(customConstraints ?? basicConstraints(_:))
        
        DispatchQueue.main.async {
            self.style()
        }
    }
    
    private func basicConstraints(_ make: ConstraintMaker) {
        guard let toast else { return }
        switch toast.config.direction {
        case .bottom:
            make.bottom.equalToSuperview().inset(64)
        case .top:
            make.top.equalToSuperview()
        case .center:
            make.centerY.equalToSuperview()
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.animate(withDuration: 0.5) {
            self.style()
        }
    }
    
    private func style() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 999
        layer.cornerRadius = 12
        backgroundColor = .flintGray700
    }
}
