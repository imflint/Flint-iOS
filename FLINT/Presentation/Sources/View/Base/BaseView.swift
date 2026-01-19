//
//  BaseView.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

public class BaseView: UIView {
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Points

    public func setUI() {}
    public func setHierarchy() {}
    public func setLayout() {}
}
