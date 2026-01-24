//
//  CollectionFolderCollectionViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

import SnapKit
import Then
import Kingfisher

public final class CollectionFolderCollectionViewCell: BaseCollectionViewCell {
    
    public var onTapCard: (() -> Void)?
    public var onTapBookmark: ((Bool, Int) -> Void)?

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
        $0.backgroundColor = .flintGray100
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
    
    public override func layoutSubviews() {
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
    
    public override func setStyle() {
        self.backgroundColor = .clear
        
        secondPosterImageView.transform = CGAffineTransform(rotationAngle: .pi / 12)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        tap.cancelsTouchesInView = false
        cardContainerView.addGestureRecognizer(tap)
        
        bookmarkView.onTap = { [weak self] isBookmarked, count in
            self?.onTapBookmark?(isBookmarked, count)
        }
    }
    
    public override func setHierarchy() {
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
    
    public override func setLayout() {
        cardContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
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
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(4)
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
    
    public override func prepare() {
        firstPosterImageView.kf.cancelDownloadTask()
        secondPosterImageView.kf.cancelDownloadTask()
        profileImageVIew.kf.cancelDownloadTask()
        
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
    
    public struct Configuration {
        public let firstPosterURL: URL?
        public let secondPosterURL: URL?
        public let profileImageURL: URL?

        public let firstPosterImage: UIImage?
        public let secondPosterImage: UIImage?
        public let profileImage: UIImage?
        public let name: String
        public let title: String
        public let description: String
        
        public let isBookmarked: Bool
        public let bookmarkedCountText: String?
        
        public init(firstPosterImage: UIImage?, secondPosterImage: UIImage?, profileImage: UIImage?, name: String, title: String, description: String, isBookmarked: Bool, bookmarkedCountText: String?) {
            self.firstPosterImage = firstPosterImage
            self.secondPosterImage = secondPosterImage
            self.profileImage = profileImage
            self.name = name
            self.title = title
            self.description = description
            self.isBookmarked = isBookmarked
            self.bookmarkedCountText = bookmarkedCountText
            
            self.firstPosterURL = nil
            self.secondPosterURL = nil
            self.profileImageURL = nil
        }
        
        public init(
            firstPosterURL: URL?,
            secondPosterURL: URL?,
            profileImageURL: URL?,
            name: String,
            title: String,
            description: String,
            isBookmarked: Bool,
            bookmarkedCountText: String?,
            placeholderFirstImage: UIImage? = nil,
            placeholderSecondImage: UIImage? = nil,
            placeholderProfileImage: UIImage? = nil
        ) {
            self.firstPosterURL = firstPosterURL
            self.secondPosterURL = secondPosterURL
            self.profileImageURL = profileImageURL

            self.firstPosterImage = placeholderFirstImage
            self.secondPosterImage = placeholderSecondImage
            self.profileImage = placeholderProfileImage

            self.name = name
            self.title = title
            self.description = description
            self.isBookmarked = isBookmarked
            self.bookmarkedCountText = bookmarkedCountText
        }

    }
    
    public func configure(_ configuration: Configuration) {

        // 1) first poster
        if let url = configuration.firstPosterURL {
            firstPosterImageView.kf.setImage(
                with: url,
                placeholder: configuration.firstPosterImage
            )
        } else {
            firstPosterImageView.image = configuration.firstPosterImage
        }

        // 2) second poster
        if let url = configuration.secondPosterURL {
            secondPosterImageView.kf.setImage(
                with: url,
                placeholder: configuration.secondPosterImage
            )
        } else {
            secondPosterImageView.image = configuration.secondPosterImage
        }

        // 3) profile
        if let url = configuration.profileImageURL {
            profileImageVIew.kf.setImage(
                with: url,
                placeholder: configuration.profileImage
            )
        } else {
            profileImageVIew.image = configuration.profileImage
        }

        nameLabel.attributedText = .pretendard(.caption1_m_12, text: configuration.name, color: .flintGray50)
        titleLabel.attributedText = .pretendard(.body1_m_16, text: configuration.title, color: .flintWhite)
        descriptionLabel.attributedText = .pretendard(.caption1_r_12, text: configuration.description, color: .flintGray300)

        bookmarkView.configure(
            isBookmarked: configuration.isBookmarked,
            countText: configuration.bookmarkedCountText
        )
    }
}
