//
//  ViewControllerFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import UIKit

public protocol ViewControllerFactory {
    func madeTabBarViewController() -> TabBarViewController
}

// TODO: - Temp

extension ViewControllerFactory {
    @MainActor public func madeTabBarViewController() -> TabBarViewController {
        return TabBarViewController()
    }
}
