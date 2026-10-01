//
//  PillView.swift
//  Presentation
//
//  Created by 소은 on 4/30/26.
//

import UIKit

import SnapKit
import Then

final class PillView: BaseView {
    
    // MARK: - UI Component
    
    private let backgroundImageView = UIImageView().then {
            let original = UIImage.userProfileBadge
            let capWidth = original.size.height / 2 
            $0.image = original.resizableImage(
                withCapInsets: UIEdgeInsets(top: 0, left: capWidth, bottom: 0, right: capWidth),
                resizingMode: .stretch
            )
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
