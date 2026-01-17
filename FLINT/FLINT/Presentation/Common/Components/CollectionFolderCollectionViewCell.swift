//
//  CollectionFolderCollectionViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class CollectionFolderCollectionViewCell: BaseCollectionViewCell {
    
    var onTapCard: (() -> Void)?
    var onTapBookmark: ((Bool) -> Void)?
    
    // MARK: - UI Component
    
    private let cardContainerView = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = false
        $0.isUserInteractionEnabled = true
    }
    
    private let cardContentView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let firstPosterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    private let secondPosterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .flintGray100
    }
    
    private let secondPosterShadowView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let folderOverlayoutView = UIImageView().then {
        $0.image = .imgFolder
        $0.isUserInteractionEnabled = false
    }
    
    private let profileImageVIew = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
    }
    
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    private let bookmarkView = BookmarkView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let textContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        firstPosterImageView.layer.cornerRadius = 12
        firstPosterImageView.clipsToBounds = true
        
        secondPosterImageView.layer.cornerRadius = 12
        secondPosterImageView.clipsToBounds = true
        
        secondPosterShadowView.layer.cornerRadius = 12
        secondPosterShadowView.layer.applyShadow(
            color: .black,
            alpha: 0.35,
            blur: 10,
            spread: 0,
            x: -4,
            y: 0,
            cornerRadius: 12
        )
    }
    
    // MARK: - Setup
    
    override func setStyle() {
        self.backgroundColor = .clear
        
        secondPosterImageView.transform = CGAffineTransform(rotationAngle: .pi / 12)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        tap.cancelsTouchesInView = false
        cardContainerView.addGestureRecognizer(tap)
        
        bookmarkView.onTap = { [weak self] isBookmarked in
            self?.onTapBookmark?(isBookmarked)
        }
    }
    
    override func setHierarchy() {
        contentView.addSubviews(cardContainerView, textContainer)
        
        cardContainerView.addSubviews(firstPosterImageView, secondPosterShadowView, cardContentView)
        
        secondPosterShadowView.addSubview(secondPosterImageView)
        
        cardContentView.addSubviews(
            folderOverlayoutView,
            profileImageVIew,
            nameLabel,
            bookmarkView
        )
        
        cardContentView.bringSubviewToFront(bookmarkView)
        textContainer.addSubviews(titleLabel, descriptionLabel)
    }
    
    override func setLayout() {
        cardContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(154)
        }
        
        cardContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        firstPosterImageView.snp.makeConstraints {
            $0.leading.equalTo(cardContainerView.snp.leading).offset(17)
            $0.top.equalTo(cardContainerView.snp.top).offset(11)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        secondPosterShadowView.snp.makeConstraints {
            $0.leading.equalTo(firstPosterImageView.snp.leading).offset(38)
            $0.top.equalTo(firstPosterImageView.snp.top).offset(15)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        secondPosterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        folderOverlayoutView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        profileImageVIew.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(9)
            $0.size.equalTo(28)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageVIew.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImageVIew)
        }
        
        bookmarkView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(74)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        textContainer.snp.makeConstraints {
            $0.top.equalTo(cardContainerView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(cardContainerView).inset(11)
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func prepare() {
        firstPosterImageView.image = nil
        secondPosterImageView.image = nil
        profileImageVIew.image = nil
        
        nameLabel.attributedText = nil
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        
        onTapCard = nil
        onTapBookmark = nil
        
    }
    
    
    // MARK: - Action
    
    @objc private func didTapCard() {
        onTapCard?()
    }
    
    // MARK: - Custom Method
    
    // MARK: - Configure
    
    struct Configuration {
        let firstPosterImage: UIImage?
        let secondPosterImage: UIImage?
        
        let profileImage: UIImage?
        let name: String
        let title: String
        let description: String
        
        let isBookmarked: Bool
        let bookmarkedCountText: String?
    }
    
    func configure(_ configuration: Configuration) {
        firstPosterImageView.image = configuration.firstPosterImage
        secondPosterImageView.image = configuration.secondPosterImage
        
        profileImageVIew.image = configuration.profileImage
        
        nameLabel.attributedText = .pretendard(.caption1_m_12, text: configuration.name, color: .flintGray50)
        titleLabel.attributedText = .pretendard(.body1_m_16, text: configuration.title, color: .flintWhite)
        descriptionLabel.attributedText = .pretendard(.caption1_r_12, text: configuration.description, color: .flintGray300)
        
        bookmarkView.configure(
            isBookmarked: configuration.isBookmarked,
            countText: configuration.bookmarkedCountText
        )
    }
}
