//
//  HomeGreetingTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

public final class HomeGreetingTableViewCell: BaseTableViewCell {
    
    // MARK: - UI
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    private let blackOverlayView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
    }
    
    private let innerShadowLayer = CAShapeLayer()
    
    private let innerShadowOverlayView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
    }
    
    private let greetingLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(backgroundImageView,blackOverlayView, innerShadowOverlayView, greetingLabel)
    }
    
    public override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blackOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        innerShadowOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        greetingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(174)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundImageView.image = UIImage.imgBackgroundGradiantMiddle
        
        innerShadowLayer.shadowColor = UIColor.flintBackground.cgColor
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 30)
        innerShadowLayer.shadowOpacity = 0.35
        innerShadowLayer.shadowRadius = 40
        innerShadowLayer.fillRule = .evenOdd
        innerShadowLayer.fillColor = UIColor.black.cgColor
        
        if innerShadowLayer.superlayer == nil {
            innerShadowOverlayView.layer.addSublayer(innerShadowLayer)
        }
    }
    
    public override func layoutSubviews() {
            super.layoutSubviews()
            updateInnerShadowPath()
        }
    
    
    private func updateInnerShadowPath() {
        let bounds = innerShadowOverlayView.bounds
        guard bounds.width > 0, bounds.height > 0 else { return }

        let inset = -innerShadowLayer.shadowRadius * 2.0

        let outerPath = UIBezierPath(rect: bounds.insetBy(dx: inset, dy: inset))
        let innerPath = UIBezierPath(rect: bounds)

        outerPath.append(innerPath)
        innerShadowLayer.path = outerPath.cgPath
        innerShadowLayer.frame = bounds
    }
    
    // MARK: - Configure
    
    public func configure(userName: String) {
        greetingLabel.attributedText = .pretendard(
            .head1_sb_22,
            text: "반가워요, \(userName) 님\n오늘은 어떤 작품이 끌리세요?",
            color: .flintWhite
        )
    }
    
    public override func prepare() {
        greetingLabel.text = nil
    }
}
