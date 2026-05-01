//
//  PillView.swift
//  Presentation
//
//  Created by 소은 on 4/30/26.
//

import UIKit

import SnapKit

final class PillView: BaseView {
    
    // MARK: - UI Component
    
    private let backgroundImageView = UIImageView().then {
        $0.image = .userProfileBadge
        $0.contentMode = .scaleToFill
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        clipsToBounds = false
    }
    
    public override func setHierarchy() {
        addSubview(backgroundImageView)
    }
    
    public override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
