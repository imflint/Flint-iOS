//
//  UICollectionView+.swift
//  Flint
//
//  Created by 김호성 on 2025.11.10.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: BaseCollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}
