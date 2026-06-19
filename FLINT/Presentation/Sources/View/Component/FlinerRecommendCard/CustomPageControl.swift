//
//  CustomPageControl.swift
//  Presentation
//
//  Created by 소은 on 4/30/26.
//

import UIKit

public final class CustomPageControl: BaseView {
    
    // MARK: - Property
    
    private var dotViews: [UIView] = []
    
    var numberOfPages: Int = 0 {
        didSet {
            updateDots()
            invalidateIntrinsicContentSize()
        }
    }
    
    var currentPage: Int = 0 {
        didSet { updateColors() }
    }
    
    // MARK: - Override
    
    public override func setUI() {
        backgroundColor = .clear
    }
    
    public override var intrinsicContentSize: CGSize {
        let width = CGFloat(numberOfPages) * 8 + CGFloat(max(0, numberOfPages - 1)) * 4
        return CGSize(width: width, height: 8)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutDots()
    }
    
    // MARK: - Custom Method
    
    private func updateDots() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        for _ in 0..<numberOfPages {
            let dot = UIView()
            dot.backgroundColor = .flintGray500
            dot.layer.cornerRadius = 4
            addSubview(dot)
            dotViews.append(dot)
        }
        
        setNeedsLayout()
    }
    
    private func layoutDots() {
        guard !dotViews.isEmpty else { return }
        
        for (index, dot) in dotViews.enumerated() {
            dot.frame = CGRect(
                x: CGFloat(index) * 12,
                y: 0,
                width: 8,
                height: 8
            )
        }
    }
    
    private func updateColors() {
        for (index, dot) in dotViews.enumerated() {
            UIView.animate(withDuration: 0.3) {
                dot.backgroundColor = index == self.currentPage ? .flintSecondary400 : .flintGray500
            }
        }
    }
}
