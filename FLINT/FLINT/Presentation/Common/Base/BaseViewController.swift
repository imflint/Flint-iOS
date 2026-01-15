//
//  BaseViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

import SnapKit

class BaseViewController: UIViewController {

    // MARK: - Component
    
    let navigationBarView = FlintNavigationBar()

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
        view.addSubview(navigationBarView)
    }
    func setLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}
