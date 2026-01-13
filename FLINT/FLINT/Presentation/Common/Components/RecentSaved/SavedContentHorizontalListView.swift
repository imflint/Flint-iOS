//
//  SavedContentHorizontalListView.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class SavedContentHorizontalListView: BaseView {
    
    //MARK: - UI
    
    private let collectionView: UICollectionView =  {
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
    
    //MARK: - Data
    
    private var items : [SavedContentItem] = []
    
    //MARK: override
    
    override func setUI() {
        setCollectionView()
    }
    
    override func setHierarchy() {
        addSubview(collectionView)
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - configure
    
    func configure(items: [SavedContentItem]) {
        self.items = items
        collectionView.reloadData()
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SavedContentCardCollectionViewCell.self,
                                forCellWithReuseIdentifier: SavedContentCardCollectionViewCell.reuseIdentifier
        )
    }
}

//MARK: - extension

extension SavedContentHorizontalListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(
           _ collectionView: UICollectionView,
           cellForItemAt indexPath: IndexPath
       ) -> UICollectionViewCell {
           
           guard let cell = collectionView.dequeueReusableCell(
               withReuseIdentifier: SavedContentCardCollectionViewCell.reuseIdentifier,
               for: indexPath
           ) as? SavedContentCardCollectionViewCell else {
               return UICollectionViewCell()
           }

           cell.configure(with: items[indexPath.item])
           return cell
       }
}

extension SavedContentHorizontalListView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 120, height: 180 + 14 + 18 + 8 + 15)
    }
}
