//
//  MainTabBar.swift
//  FLINT
//
//  Created by 소은 on 1/7/26.
//

import UIKit

enum MainTabBar: CaseIterable {
    case home
    case explore
    case my
}

extension MainTabBar {
    var title: String {
        switch self {
        case .home: return "홈"
        case .explore: return "탐색"
        case .my: return "MY"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home: return .icHomeEmpty
        case .explore: return .icExploreEmpty
        case .my: return .icMyEmpty
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home: return HomeViewController()
        case .explore: return ExploreViewController()
        case .my: return MyViewController()
        }
    }
}
