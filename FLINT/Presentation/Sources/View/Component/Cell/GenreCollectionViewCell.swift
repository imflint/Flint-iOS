//
//  GenreCollectionViewCell.swift
//  Presentation
//
//  Created by 김호성 on 2026.05.13.
//

import UIKit

import Domain

public final class GenreCollectionViewCell: BaseCollectionViewCell {
    
    public override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            capsuleButton.style = newValue ? .colored : .outlined
        }
    }
    
    public let capsuleButton = CapsuleButton(style: .outlined).then {
        $0.isUserInteractionEnabled = false
    }
    
//    public override func prepare() {
//        super.prepare()
//        
//        capsuleButton.removeTarget(nil, action: nil, for: .allEvents)
//    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubview(capsuleButton)
    }
    
    public override func setLayout() {
        capsuleButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func configure(genre: Genre) {
        capsuleButton.title = genre.title
    }
}
