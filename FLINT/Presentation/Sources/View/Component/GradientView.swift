//
//  GradientView.swift
//  Flint
//
//  Created by 김호성 on 2025.03.12.
//

import UIKit

public final class GradientView: UIView {
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    public var colors: [UIColor] = [] {
        didSet {
            gradientLayer?.colors = colors.map(\.cgColor)
        }
    }
    
    public var locations: [NSNumber] = [] {
        didSet {
            gradientLayer?.locations = locations
        }
    }
    
    public var startPoint: CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet {
            gradientLayer?.startPoint = startPoint
        }
    }
    public var endPoint: CGPoint = CGPoint(x: 1, y: 0.5) {
        didSet {
            gradientLayer?.endPoint = endPoint
        }
    }
}
