//
//  OnboardingFilmCollectionViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.17.
//

import UIKit

import SnapKit
import Then

final class OnboardingFilmCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView().then {
        $0.backgroundColor = .flintGray100
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 2
    }
    
    let directorLabel = UILabel().then {
        $0.textColor = .flintGray300
        $0.numberOfLines = 1
    }
    
    let yearLabel = UILabel().then {
        $0.textColor = .flintGray300
        $0.numberOfLines = 1
    }
    
    override func setHierarchy() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            directorLabel,
            yearLabel,
        )
    }
    
    override func setLayout() {
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
    }
}
