//
//  BaseViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import Combine
import UIKit

import SnapKit
import Then

import View

public class BaseViewController<RootView: UIView>: UIViewController {
    
    // MARK: - Property
    
    public var viewControllerFactory: ViewControllerFactory?
    public var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Component
    
    public let statusBarBackgroundView = UIView().then {
        $0.isHidden = true
    }
    public let navigationBarView = FlintNavigationBar().then {
        $0.isHidden = true
    }
    public let rootView: RootView = RootView()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setBaseUI()
        setBaseHierarchy()
        setBaseLayout()
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    // MARK: - Setup
    
    public func setBaseUI() {
        
    }
    
    public func setBaseHierarchy() {
        view.addSubviews(statusBarBackgroundView, navigationBarView, rootView)
    }
    
    public func setBaseLayout() {
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(navigationBarView.snp.top)
        }
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        rootView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Override Points
    
    public func setUI() {
        
    }
    
    public func setHierarchy() {
        
    }
    
    public func setLayout() {
        
    }
}
