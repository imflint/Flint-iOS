//
//  CreateCollectionHeaderImageCell.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class CreateCollectionHeaderImageCell: BaseTableViewCell {
    
    private let headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = .imgBackgroundGradiantMiddle
    }
    
    private let blackOverlayView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
    }
    
    override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        contentView.addSubviews(headerImageView, blackOverlayView)
    }
    
    override func setLayout() {
        headerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        blackOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
