//
//  FilmPreviewCollectionViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.10.
//

import UIKit

import SnapKit
import Then

final class FilmPreviewCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Component
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .flintGray100
    }
    
    let xButton = UIButton().then {
        $0.setImage(.icDeselect, for: .normal)
    }
    
    // MARK: - Basic
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = (bounds.height - 12) / 2
    }
    
    // MARK: - Setup
    
    override func setHierarchy() {
        contentView.addSubviews(imageView, xButton)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(80)
        }
        
        xButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
    
    override func prepare() {
        imageView.image = nil
        xButton.removeTarget(nil, action: nil, for: .allEvents)
    }
}
