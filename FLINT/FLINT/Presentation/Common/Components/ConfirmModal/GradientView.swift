//
//  GradientView.swift
//  FLINT
//
//  Created by 소은 on 1/9/26.
//

import UIKit

// MARK: - GradientView

final class GradientView: UIView {

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        gradientLayer.colors = [
            UIColor.flintGray600.cgColor,
            UIColor.flintGray700.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
