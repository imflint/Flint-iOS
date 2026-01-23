//
//  OttSelectView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

import SnapKit
import Then

public class OttSelectView: BaseView {
    
    // MARK: - Component
    
    public let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 0
    }
    
    public let ottCollectionView: UICollectionView = {
        let uselessHeight: CGFloat = 130
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .estimated(uselessHeight)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(uselessHeight)
            ),
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        section.contentInsets = .zero
        collectionView.backgroundColor = .flintBackground
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(OnboardingOttCollectionViewCell.self)
        return collectionView
    }()
    
    public let nextButton = FlintButton(style: .able, title: "다음")
    
    // MARK: - Basic
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        backgroundColor = .flintBackground
    }
    
    public override func setHierarchy() {
        addSubviews(titleLabel, ottCollectionView, nextButton)
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        ottCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(ottCollectionView.snp.bottom).offset(8)
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
