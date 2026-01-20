//
//  CollectionFolderListView.swift
//  FLINT
//
//  Created by 소은 on 1/20/26.
//


import UIKit

import SnapKit
import Then

final class CollectionFolderListView: BaseView {
    
    //MARK: UI
    

    let countLabel = UILabel()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 18, left: 20, bottom: 24, right: 20)
        layout.itemSize = CGSize(width: 154, height: 246)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func setUI() {
        backgroundColor = .flintBackground
        
        countLabel.numberOfLines = 1
        countLabel.attributedText = .pretendard(.body2_r_14, text: "총 0개", color: .red)
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(
            CollectionFolderCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: CollectionFolderCollectionViewCell.self)
        )
    }
    
    override func setHierarchy() {
        addSubviews(countLabel, collectionView)
    }
    
    override func setLayout() {
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(14)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
