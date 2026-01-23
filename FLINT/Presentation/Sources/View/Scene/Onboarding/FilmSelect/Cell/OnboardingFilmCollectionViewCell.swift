//
//  OnboardingFilmCollectionViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.17.
//

import UIKit

import SnapKit
import Then

public final class OnboardingFilmCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Component
    
    public let imageView = UIImageView().then {
        $0.backgroundColor = .flintGray100
        $0.contentMode = .scaleAspectFill
    }
    
    public let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 2
    }
    
    public let directorLabel = UILabel().then {
        $0.textColor = .flintGray300
        $0.numberOfLines = 1
    }
    
    public let yearLabel = UILabel().then {
        $0.textColor = .flintGray300
        $0.numberOfLines = 1
    }
    
    public let overlayView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .flintOverlay
    }
    
    public let checkImageView = UIImageView().then {
        $0.image = .icPlainCheck
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Basic
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            directorLabel,
            yearLabel,
            overlayView
        )
        overlayView.addSubview(checkImageView)
    }
    
    public override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(3.0 / 2.0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
        }
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        checkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
    }
}
