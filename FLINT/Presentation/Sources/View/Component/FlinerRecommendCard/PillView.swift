//
//  PillView.swift
//  Presentation
//
//  Created by 소은 on 4/30/26.
//


import UIKit
import SnapKit

final class PillView: BaseView {
    
    // MARK: - Properties
    
    private var gradientBorder: CAGradientLayer?
    
    // MARK: - Override Points
    
    public override func setUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        layer.cornerRadius = 20
        clipsToBounds = false
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0 else { return }
        
        gradientBorder?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.7).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradient.mask = shape
        layer.addSublayer(gradient)
        gradientBorder = gradient
    }
}
