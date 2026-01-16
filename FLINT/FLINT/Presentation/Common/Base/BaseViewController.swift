//
//  BaseViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

import SnapKit

class BaseViewController<RootView: UIView>: UIViewController {
    
    // MARK: - Component
    
    let navigationBarView = FlintNavigationBar()
    let rootView: RootView = RootView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    // MARK: - Override Points
    
    func setUI() {}
    func setHierarchy() {
        view.addSubviews(navigationBarView, rootView)
    }
    func setLayout() {
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
}
