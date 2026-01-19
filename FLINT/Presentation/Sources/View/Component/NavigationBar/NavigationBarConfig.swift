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

public enum NavigationBarBackgroundStyle {
    case solid(UIColor)
    case clear
}

public struct NavigationBarConfig {
    public let left: NavLeftItem
    public let title: String?
    public let right: NavRightItem
    public let backgroundStyle: NavigationBarBackgroundStyle

    public init(
        left: NavLeftItem,
        title: String? = nil,
        right: NavRightItem = .none,
        backgroundStyle: NavigationBarBackgroundStyle = .solid(DesignSystem.Color.background)
    ) {
        self.left = left
        self.title = title
        self.right = right
        self.backgroundStyle = backgroundStyle
    }
}

