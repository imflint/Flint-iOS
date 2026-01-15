//
//  TabBarViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.15.
//

import UIKit

import SnapKit
import Then

class TabBarViewController: BaseViewController {
    
    // MARK: - Child ViewController
    
    private let homeViewController = UINavigationController(rootViewController: HomeViewController())
    private let exploreViewController = UINavigationController(rootViewController: ExploreViewController())
    private let myViewController = UINavigationController(rootViewController: MyViewController())
    
    // MARK: - Component
    
    private let tabBarView = TabBarView().then {
        $0.selectedTab = .home
    }
    private let containerView = UIView()
    
    // MARK: - Property
    
    private var containerViewController: UINavigationController?
    
    // MARK: - Basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchTab(to: .home)
        
        containerViewController = homeViewController
        
        tabBarView.homeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.switchTab(to: .home)
        }), for: .touchUpInside)
        tabBarView.exploreButton.addAction(UIAction(handler: { [weak self] _ in
            self?.switchTab(to: .explore)
        }), for: .touchUpInside)
        tabBarView.myButton.addAction(UIAction(handler: { [weak self] _ in
            self?.switchTab(to: .my)
        }), for: .touchUpInside)
    }
    
    // MARK: - Setup
    
    override func setHierarchy() {
        view.addSubviews(containerView, tabBarView)
    }
    
    override func setLayout() {
        tabBarView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.bottom.equalTo(tabBarView.snp.top).offset(12)
            $0.top.horizontalEdges.equalToSuperview()
        }
    }
    
    private func switchTab(to tab: TabBarView.Tab) {
        containerViewController?.willMove(toParent: nil)
        containerViewController?.removeFromParent()
        containerViewController?.view.removeFromSuperview()
        
        let newContainerViewController: UINavigationController
        switch tab {
        case .home:
            newContainerViewController = homeViewController
        case .explore:
            newContainerViewController = exploreViewController
        case .my:
            newContainerViewController = myViewController
        }
        
        newContainerViewController.setNavigationBarHidden(true, animated: false)
        addChild(newContainerViewController)
        newContainerViewController.view.frame = containerView.bounds
        containerView.addSubview(newContainerViewController.view)
        newContainerViewController.didMove(toParent: self)
        
        tabBarView.selectedTab = tab
    }
}
