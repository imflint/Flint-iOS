//
//  TabBarViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.15.
//

import UIKit

import SnapKit
import Then

import View

public class TabBarViewController: UIViewController {
    
    // MARK: - DI
    
    public var viewControllerFactory: ViewControllerFactory?
    
    // MARK: - Child ViewController
    
    private let homeViewController: HomeViewController
    private let exploreViewController = ExploreViewController()
    private let myViewController = MyViewController()
    
    // MARK: - Component
    
    private let tabBarView = TabBarView().then {
        $0.selectedTab = .home
    }
    private let containerView = UIView()
    
    // MARK: - Property
    
    private var containerViewController: UIViewController?
    
    // MARK: - Basic
    
    public init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory
        self.homeViewController = viewControllerFactory.makeHomeViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        
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
    
    private func setHierarchy() {
        view.addSubviews(containerView, tabBarView)
    }
    
    private func setLayout() {
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
        
        let newContainerViewController: UIViewController
        switch tab {
        case .home:
            newContainerViewController = homeViewController
        case .explore:
            newContainerViewController = exploreViewController
        case .my:
            newContainerViewController = myViewController
        }
        
        addChild(newContainerViewController)
        newContainerViewController.view.frame = containerView.bounds
        containerView.addSubview(newContainerViewController.view)
        newContainerViewController.didMove(toParent: self)
        
        tabBarView.selectedTab = tab
    }
}
