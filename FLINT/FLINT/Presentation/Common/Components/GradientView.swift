//
//  GradientView.swift
//  Flint
//
//  Created by 김호성 on 2025.03.12.
//

import UIKit

final class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    var colors: [UIColor] = [] {
        didSet {
            gradientLayer?.colors = colors.map(\.cgColor)
        }
    }
    
    var locations: [NSNumber] = [] {
        didSet {
            gradientLayer?.locations = locations
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet {
            gradientLayer?.startPoint = startPoint
        }
    }
     var endPoint: CGPoint = CGPoint(x: 1, y: 0.5) {
        didSet {
            gradientLayer?.endPoint = endPoint
        }
    }
}
