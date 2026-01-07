//
//  PlainToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 30/06/2021.
//

import UIKit

import SnapKit
import Then

public class PlainToastView: UIView, ToastView {
    
    // MARK: - Property
    private var toast: Toast?
    
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
    public init(image: UIImage? = nil, title: String) {
        super.init(frame: .zero)
        
        setupUI()
        
        imageView.image = image
        titleLabel.text = title
        titleLabel.applyFontStyle(.body2_r_14)
        
        imageView.isHidden = image == nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromSuperview() {
      super.removeFromSuperview()
      self.toast = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews(imageView, titleLabel)
    }
    
    private func setupLayout() {
        mainStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(9)
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    // MARK: - Function
    public func createView(for toast: Toast) {
        self.toast = toast
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -10),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ]
        
        
        switch toast.config.direction {
        case .bottom:
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor, constant: -64).isActive = true
        case .top:
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        case .center:
            centerYAnchor.constraint(equalTo: superview.layoutMarginsGuide.centerYAnchor, constant: 0).isActive = true
        }
        
        NSLayoutConstraint.activate(constraints)
        DispatchQueue.main.async {
            self.style()
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
        layer.cornerRadius = frame.height / 2
        backgroundColor = .flintGray700
    }
}
