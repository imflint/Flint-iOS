//
//  RecentSavedContentHorizontalListTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

public final class RecentSavedContentTableViewCell: BaseTableViewCell {
    
    public var onTapItem: ((RecentSavedContentItem) -> Void)?
    
    // MARK: - UI
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
        }
    }()
    
    // MARK: - Data
    
    private var items: [RecentSavedContentItem] = []
    
    // MARK: - Override
    
    public override func setStyle() {
        backgroundColor = .clear
    }
    
    public override func setHierarchy() {
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            RecentSavedContentCardCollectionViewCell.self,
            forCellWithReuseIdentifier: RecentSavedContentCardCollectionViewCell.reuseIdentifier
        )
    }
    
    
    public override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(226)   
        }
    }
    
    public override func prepare() {
        items = []
        collectionView.setContentOffset(.zero, animated: false)
        collectionView.reloadData()
    }
    
    // MARK: - Configure
    
    public func configure(items: [RecentSavedContentItem]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension RecentSavedContentTableViewCell: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecentSavedContentCardCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? RecentSavedContentCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension RecentSavedContentTableViewCell: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem?(items[indexPath.item])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecentSavedContentTableViewCell: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 120, height: 226)
    }
}
