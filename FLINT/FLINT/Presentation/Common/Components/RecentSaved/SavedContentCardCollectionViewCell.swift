//
//  SavedContentCardCollectionViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class SavedContentCardCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }

    private let logoStripView = OTTLogoStripeView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let yearLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 1
    }
    
    //MARK: override
    
    override func setStyle() {
        contentView.backgroundColor = .clear
    }
    
    override func setHierarchy() {
        contentView.addSubviews(posterImageView, titleLabel, yearLabel)
        
        posterImageView.addSubview(logoStripView)
    }
    
    override func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        logoStripView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func prepare() {
        posterImageView.image = nil
        titleLabel.attributedText = nil
        yearLabel.attributedText = nil
        logoStripView.isHidden = true
    }
    
    //MARK: - configure
    
    func configure(with item: SavedContentItem) {

        posterImageView.image = UIImage(named: item.posterImageName)
        
        titleLabel.attributedText = .pretendard(.body1_b_16,
                                                text: item.title,
                                                color: .flintWhite)
        
        yearLabel.attributedText = .pretendard(.caption1_r_12,
                                               text: "\(item.year)",
                                               color: .flintGray300 )
        let display = item.logoDisplayModel
        logoStripView.configure(leading: display.leading, remainingCount: display.remainingCount)
    }
}
