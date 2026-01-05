//
//  BaseCollectionViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//


import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        prepare()
    }
    
    // MARK: - Override Points

    func setStyle() { }
    func setHierarchy() { }
    func setLayout() { }
    func prepare() { }
}
