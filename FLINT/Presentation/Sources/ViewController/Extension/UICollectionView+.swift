//
//  UICollectionView+.swift
//  Presentation
//
//  Created by 김호성 on 2026.02.10.
//

import UIKit

import View

extension UICollectionView {
    public func dequeueReusableCell<T: BaseCollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell: T = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell of type \(cellType) with reuseIdentifier \(cellType.reuseIdentifier).")
        }
        return cell
    }
}
