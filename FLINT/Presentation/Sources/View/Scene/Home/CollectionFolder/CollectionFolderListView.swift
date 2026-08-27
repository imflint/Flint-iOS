//
//  CollectionFolderListView.swift
//  FLINT
//
//  Created by 소은 on 1/20/26.
//

import UIKit

import SnapKit
import Then

public final class CollectionFolderListView: BaseView {
    
    // MARK: - UI
    
    public let countLabel = UILabel()
    
    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 18, left: 20, bottom: 24, right: 20)
        layout.itemSize = CGSize(width: 154, height: 246)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let bottomGradientView = GradientView().then {
        $0.colors = [
            DesignSystem.Color.background.withAlphaComponent(0),
            DesignSystem.Color.background
        ]
        $0.locations = [0.0, 1.0]
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    public override func setUI() {
        backgroundColor = .flintBackground
        
        countLabel.numberOfLines = 1
        countLabel.isHidden = true
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(
            CollectionFolderCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: CollectionFolderCollectionViewCell.self)
        )
        collectionView.register(
            CollectionFolderHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionFolderHeaderView.identifier
        )
    }
    
    public override func setHierarchy() {
        addSubviews(countLabel, collectionView, bottomGradientView)
    }
    
    public override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomGradientView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(195)
        }
    }
}
