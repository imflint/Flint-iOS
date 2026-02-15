//
//  UITableView+.swift
//  Presentation
//
//  Created by 김호성 on 2026.02.14.
//

import UIKit

import View

extension UITableView {
    public func dequeueReusableCell<T: BaseTableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell: T = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell of type \(cellType) with reuseIdentifier \(cellType.reuseIdentifier).")
        }
        return cell
    }
}
