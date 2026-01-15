//
//  ExploreView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.15.
//

import UIKit

import SnapKit
import Then

class ExploreView: BaseView {
    
    // MARK: - Component
    
    let gradientBackgroundView = FixedGradientView().then {
        $0.colors = [.flintGray600, .flintGray700]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0.1, y: 0)
        $0.endPoint = .init(x: 0.5, y: 0.6)
    }
    
    let mainCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0
        }
    ).then {
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never
        $0.isPagingEnabled = true
        $0.decelerationRate = .fast
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .zero
    }
    
    // MARK: - Basic
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setUI() {
        backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        addSubviews(gradientBackgroundView, mainCollectionView)
    }
    
    override func setLayout() {
        gradientBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mainCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
