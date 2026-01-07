//
//  MainTabBarController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Properties

    private let tabBarBackgroundView = UIView()
    private let tabBarCornerRadius: CGFloat = 12
    private let backgroundLift: CGFloat = 10

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.flintGray800

        configureTabBarAppearance()
        configureTabBarBackground()
        configureTabs()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var frame = tabBar.frame
        frame.origin.y -= backgroundLift
        frame.size.height += backgroundLift

        tabBarBackgroundView.frame = frame
    }

    // MARK: - Configuration

    private func configureTabBarAppearance() {
        tabBar.tintColor = UIColor.flintGray100
        tabBar.unselectedItemTintColor = UIColor.flintGray600

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        let itemAppearance = UITabBarItemAppearance()

        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)

        itemAppearance.normal.iconColor = UIColor.flintGray600
        itemAppearance.selected.iconColor = UIColor.flintGray100

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    private func configureTabBarBackground() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.isTranslucent = true

        tabBarBackgroundView.backgroundColor = UIColor.flintGray800
        tabBarBackgroundView.layer.cornerRadius = tabBarCornerRadius
        tabBarBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBarBackgroundView.layer.masksToBounds = false

        if tabBarBackgroundView.superview == nil {
            view.insertSubview(tabBarBackgroundView, belowSubview: tabBar)
        }
    }

    private func configureTabs() {
        let home = HomeViewController()
        home.tabBarItem = makeTabItem(title: "홈", imageName: "ic_home_empty")

        let explore = ExploreViewController()
        explore.tabBarItem = makeTabItem(title: "탐색", imageName: "ic_explore_empty")

        let my = MyViewController()
        my.tabBarItem = makeTabItem(title: "MY", imageName: "ic_my_empty")

        viewControllers = [
            UINavigationController(rootViewController: home),
            UINavigationController(rootViewController: explore),
            UINavigationController(rootViewController: my)
        ]

    }


    // MARK: - Helpers

    private func makeTabItem(title: String, imageName: String) -> UITabBarItem {
        let image = UIImage(named: imageName)?
            .withRenderingMode(.alwaysTemplate)
        
        return UITabBarItem(title: title, image: image, selectedImage: image)
    }
}
