//
//  BaseViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    // MARK: - Override Points
    
    func setUI() {}
    func setHierarchy() {}
    func setLayout() {}
}
