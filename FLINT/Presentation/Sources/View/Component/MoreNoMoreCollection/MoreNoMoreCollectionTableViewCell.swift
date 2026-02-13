//
//  MoreNoMoreCollectionTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

import Entity

public final class MoreNoMoreCollectionTableViewCell: BaseTableViewCell {

    public var onSelectItem: ((CollectionEntity) -> Void)?
    private var items: [CollectionEntity] = []
    
    // MARK: - UI
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        $0.register(
            MoreNoMoreCollectionItemCell.self,
            forCellWithReuseIdentifier: MoreNoMoreCollectionItemCell.reuseIdentifier
        )
    }
    
    // MARK: - BaseTableViewCell
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    public override func setHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    public override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(260)
            $0.height.equalTo(180)
        }
    }
    
    public override func prepare() {
        onSelectItem = nil
        items = []
        collectionView.reloadData()
    }
    
    // MARK: - Public
    
    public func configure(items: [CollectionEntity]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource / Delegate

extension MoreNoMoreCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoreNoMoreCollectionItemCell.reuseIdentifier,
            for: indexPath
        ) as? MoreNoMoreCollectionItemCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(entity: items[indexPath.item])

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.item])
    }
}

// MARK: - Layout

private extension MoreNoMoreCollectionTableViewCell {
    
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        layout.itemSize = CGSize(width: 260, height: 180)
        
        return layout
    }
}
