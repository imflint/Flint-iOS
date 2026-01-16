//
//  BaseViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

import SnapKit
import Then

class BaseViewController<RootView: UIView>: UIViewController {
    
    // MARK: - Component
    
    let statusBarBackgroundView = UIView().then {
        $0.isHidden = true
    }
    let navigationBarView = FlintNavigationBar().then {
        $0.isHidden = true
    }
    let rootView: RootView = RootView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
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
    
    private func setBaseUI() {
        
    }
    
    private func setBaseHierarchy() {
        view.addSubviews(statusBarBackgroundView, navigationBarView, rootView)
    }
    
    private func setBaseLayout() {
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
    
    func setUI() {
        
    }
    
    func setHierarchy() {
        
    }
    
    func setLayout() {
        
    }
}
