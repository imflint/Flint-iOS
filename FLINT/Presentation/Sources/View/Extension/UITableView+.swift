//
//  UITableView+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.17.
//

import UIKit

extension UITableView {
    public func register(_ cellClass: BaseTableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}
