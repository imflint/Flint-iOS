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
    private let topBackgroundExtra: CGFloat = 12

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        configureTabs()
        configureTabBarBackground()
        tabBarBackgroundView.frame = tabBar.frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var bgFrame = tabBar.frame
        bgFrame.origin.y -= topBackgroundExtra
        bgFrame.size.height = tabBar.frame.height + topBackgroundExtra

        tabBarBackgroundView.frame = bgFrame
        tabBarBackgroundView.layer.cornerRadius = tabBarCornerRadius
        tabBarBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBarBackgroundView.layer.masksToBounds = true
    }


    // MARK: - Configuration

    private func configureTabs() {
        let controllers = MainTabBar.allCases.map { tab -> UIViewController in
            let vc = tab.viewController

            let icon = tab.icon?.withRenderingMode(.alwaysTemplate)

            vc.tabBarItem = UITabBarItem(
                title: tab.title,
                image: icon,
                selectedImage: icon
            )

            vc.tabBarItem.setTitleTextAttributes(
                [.font: TypographyStyle.micro1_m_10.font],
                for: .normal
            )
            vc.tabBarItem.setTitleTextAttributes(
                [.font: TypographyStyle.micro1_m_10.font],
                for: .selected
            )

            return vc
        }

        viewControllers = controllers
    }

    private func configureTabBarAppearance() {
        tabBar.tintColor = UIColor.flintGray100
        tabBar.unselectedItemTintColor = UIColor.flintGray600

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        appearance.shadowColor = .clear

        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func configureTabBarBackground() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor.clear
        tabBar.isTranslucent = true

        tabBarBackgroundView.backgroundColor = UIColor.flintGray800
        tabBarBackgroundView.layer.cornerRadius = tabBarCornerRadius
        tabBarBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBarBackgroundView.layer.masksToBounds = false

        if tabBarBackgroundView.superview == nil {
            view.insertSubview(tabBarBackgroundView, belowSubview: tabBar)
        }
    }
}
