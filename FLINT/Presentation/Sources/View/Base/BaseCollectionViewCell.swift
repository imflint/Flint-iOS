//
//  BaseCollectionViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

public class BaseCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    public override func prepareForReuse() {
        super.prepareForReuse()
        prepare()
    }
    
    // MARK: - Override Points

    public func setStyle() { }
    public func setHierarchy() { }
    public func setLayout() { }
    public func prepare() { }
}
