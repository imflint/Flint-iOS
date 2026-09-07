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
    case kebab
    case setting
    case text(title: String, color: UIColor)
    case icon(name: String, tint: UIColor)
    case none
}

public enum NavigationBarBackgroundStyle {
    case solid(UIColor)
    case clear
    /// 상단 → 하단으로 페이드되는 그라디언트 (상태바 영역은 top 색상으로 solid)
    case verticalGradient(top: UIColor, bottom: UIColor)
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

