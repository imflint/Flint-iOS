//
//  NavigationBarConfig.swift
//  FLINT
//
//  Created by 진소은 on 1/14/26.
//

import UIKit

public enum NavLeftItem {
    case back
    case logo
    case none
}

public enum NavRightItem {
    case close
    case text(title: String, color: UIColor)
    case none
}

enum NavigationBarBackgroundStyle {
    case solid(UIColor)
    case clear
}

struct NavigationBarConfig {
    let left: NavLeftItem
    let title: String?
    let right: NavRightItem
    let backgroundStyle: NavigationBarBackgroundStyle

    init(
        left: NavLeftItem,
        title: String? = nil,
        right: NavRightItem = .none,
        backgroundStyle: NavigationBarBackgroundStyle = .solid(.flintBackground)
    ) {
        self.left = left
        self.title = title
        self.right = right
        self.backgroundStyle = backgroundStyle
    }
}

