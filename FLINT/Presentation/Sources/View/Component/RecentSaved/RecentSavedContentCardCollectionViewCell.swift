//
//  SavedContentCardCollectionViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit
import Then

import Entity

public final class RecentSavedContentCardCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI
    
    private let posterContainerView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let logoStripView = OTTLogoStripeView()
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let yearLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    //MARK: override
    
    public override func setStyle() {
        contentView.backgroundColor = .clear
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(posterContainerView, titleLabel, yearLabel)
        posterContainerView.addSubviews(posterImageView, logoStripView)
    }
    
    public override func setLayout() {
        posterContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 120, height: 180))
        }
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoStripView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterContainerView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    public override func prepare() {
        posterImageView.image = nil
        titleLabel.attributedText = nil
        yearLabel.attributedText = nil
        logoStripView.isHidden = true
    }
    
    //MARK: - configure
    
    public func configure(with item: ContentInfoEntity) {
        if let url = URL(string: item.imageUrl) {
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = nil
        }
        
        titleLabel.attributedText = .pretendard(.body1_b_16,
                                                text: item.title,
                                                color: .flintWhite)
        
        yearLabel.attributedText = .pretendard(.caption1_r_12,
                                               text: "\(item.year)",
                                               color: .flintGray300)
        
        let names = item.ottList.map { $0.ottName }
        let leading = Array(names.prefix(2))
        let remaining = max(names.count - leading.count, 0)
        logoStripView.configure(leadingServerNames: leading, remainingCount: remaining)
        
        logoStripView.isHidden = leading.isEmpty && remaining == 0
    }
}

public extension ContentInfoEntity {
    
    var logoDisplayModel: (leading: [String], remainingCount: Int) {
        let urls = ottList.map { $0.logoUrl }.filter { !$0.isEmpty }
        let leading = Array(urls.prefix(2))
        let remaining = max(urls.count - leading.count, 0)
        return (leading, remaining)
    }
}
