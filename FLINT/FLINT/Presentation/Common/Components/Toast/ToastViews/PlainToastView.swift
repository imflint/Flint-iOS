//
//  PlainToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 30/06/2021.
//

import UIKit

import SnapKit
import Then

final class PlainToastView: BaseView, ToastView {
    
    // MARK: - Property
    
    private var toast: Toast?
    private var customConstraints: ((_ make: ConstraintMaker) -> Void)?
    
    // MARK: - Component
    
    private var mainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.applyFontStyle(.body2_r_14)
        $0.textColor = .flintWhite
    }
    
    // MARK: - Basic
    
    init(image: UIImage? = nil, title: String, customConstraints: ((_ make: ConstraintMaker) -> Void)? = nil) {
        super.init(frame: .zero)
        
        imageView.image = image
        titleLabel.text = title
        self.customConstraints = customConstraints
        titleLabel.applyFontStyle(.body2_r_14)
        
        imageView.isHidden = image == nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
      super.removeFromSuperview()
      self.toast = nil
    }
    
    // MARK: - Setup
    
    override func setHierarchy() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews(imageView, titleLabel)
    }
    
    override func setLayout() {
        mainStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(9)
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    // MARK: - Function
    
    func createView(for toast: Toast) {
        self.toast = toast
        snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(10)
            $0.trailing.lessThanOrEqualToSuperview().inset(10)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.animate(withDuration: 0.5) {
            self.style()
        }
    }
    
    private func style() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 999
        layer.cornerRadius = frame.height / 2
        backgroundColor = .flintGray700
    }
}
