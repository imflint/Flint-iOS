//
//  ExploreCollectionViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.15.
//

import UIKit

import SnapKit
import Then

class ExploreCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Component
    
    let collectionImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let gradientView = GradientView().then {
        $0.colors = [.clear, .clear, UIColor(hex: 0x000000, alpha: 0.8)]
        $0.locations = [0, 0.35, 1]
        $0.startPoint = .init(x: 0.5, y: 0.0)
        $0.endPoint = .init(x: 0.5, y: 1.0)
    }
    
    // MARK: - Basic
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        addSubviews(
            collectionImageView,
            gradientView
        )
    }
    
    override func setLayout() {
        collectionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepare() {
        
    }
}
