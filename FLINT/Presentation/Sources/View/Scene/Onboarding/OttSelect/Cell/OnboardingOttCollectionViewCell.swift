//
//  OnboardingOttCollectionViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

import SnapKit
import Then

public final class OnboardingOttCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Component
    
    public let imageView = UIImageView().then {
        $0.backgroundColor = .flintGray100
        $0.contentMode = .scaleAspectFill
    }
    
    public let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.textAlignment = .center
    }
    
    
    // MARK: - Basic
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(
            imageView,
            titleLabel,
        )
    }
    
    public override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(contentView.snp.width)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
