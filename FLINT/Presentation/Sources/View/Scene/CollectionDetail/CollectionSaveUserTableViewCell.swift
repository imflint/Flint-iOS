//
//  CollectionSaveUserTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/20/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

public final class CollectionSaveUserTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    public var onTapMore: (() -> Void)?
    
    // MARK: - Component
    
    private let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.head2_sb_20, text: "이 컬렉션을 저장한 사람들", color: .white)
        $0.numberOfLines = 1
    }
    
    private let chevronButton = UIButton(type: .system).then {
        $0.setImage(UIImage(resource: .icMore), for: .normal)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .trailing
    }
    
    private let headerView = UIView()
    private let avatarsContainerView = UIView()
    
    private var avatarImageViews: [UIImageView] = []
    private let maxAvatarCount = 6
    private let avatarSize: CGFloat = 56
    private let overlap: CGFloat = 12
    
    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bind()
    }
    
    // MARK: - Bind
    
    private func bind() {
        chevronButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    // MARK: - Setup
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(headerView, avatarsContainerView)
        headerView.addSubviews(titleLabel, chevronButton)
    }
    
    public override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        chevronButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        avatarsContainerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(avatarSize)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        onTapMore = nil
        clearAvatars()
    }
    
    // MARK: - Action
    
    @objc private func didTapMore() {
        onTapMore?()
    }
    
    // MARK: - Configure
    
    public func configure(title: String = "이 컬렉션을 저장한 사람들", profileImageURLs: [URL?]) {
        titleLabel.attributedText = .pretendard(.head2_sb_20, text: title, color: .white)
        setAvatars(urls: profileImageURLs)
    }
    
    public func configure(title: String = "이 컬렉션을 저장한 사람들", images: [UIImage]) {
        titleLabel.attributedText = .pretendard(.head2_sb_20, text: title, color: .white)
        setAvatars(images: images)
    }
    
    // MARK: - Private
    
    private func setAvatars(urls: [URL?]) {
        clearAvatars()
        
        let displayURLs = Array(urls.prefix(maxAvatarCount))
        var previous: UIImageView?
        
        // placeholder 타입 이슈 대비: UIImage?로 명시
        let placeholderImage: UIImage? = DesignSystem.Image.Common.profileGray
        
        for (idx, url) in displayURLs.enumerated() {
            let iv = UIImageView().then {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.layer.cornerRadius = avatarSize / 2
                $0.backgroundColor = .flintGray300
                $0.layer.borderWidth = 3
                $0.layer.borderColor = UIColor.flintBackground.cgColor
            }
            
            iv.kf.setImage(with: url, placeholder: placeholderImage)
            
            avatarsContainerView.addSubview(iv)
            avatarImageViews.append(iv)
            
            iv.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.size.equalTo(avatarSize)
                
                if let previous {
                    $0.leading.equalTo(previous.snp.trailing).offset(-overlap)
                } else {
                    $0.leading.equalToSuperview()
                }
            }
            
            iv.layer.zPosition = CGFloat(idx)
            previous = iv
        }
        
        // trailing 제약은 한 번만, 누적되지 않게 remake로 처리
        if let last = previous {
            avatarsContainerView.snp.remakeConstraints {
                $0.top.equalTo(headerView.snp.bottom).offset(16)
                $0.leading.equalToSuperview().inset(16)
                $0.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(avatarSize)
                $0.bottom.equalToSuperview().inset(20)
                $0.trailing.greaterThanOrEqualTo(last.snp.trailing)
            }
        }
    }
    
    private func setAvatars(images: [UIImage]) {
        clearAvatars()
        
        let displayImages = Array(images.prefix(maxAvatarCount))
        var previous: UIImageView?
        
        for (idx, image) in displayImages.enumerated() {
            let iv = UIImageView().then {
                $0.image = image
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.layer.cornerRadius = avatarSize / 2
                $0.backgroundColor = .flintGray300
                $0.layer.borderWidth = 3
                $0.layer.borderColor = UIColor.flintBackground.cgColor
            }
            
            avatarsContainerView.addSubview(iv)
            avatarImageViews.append(iv)
            
            iv.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.size.equalTo(avatarSize)
                
                if let previous {
                    $0.leading.equalTo(previous.snp.trailing).offset(-overlap)
                } else {
                    $0.leading.equalToSuperview()
                }
            }
            
            iv.layer.zPosition = CGFloat(idx)
            previous = iv
        }
        
        if let last = previous {
            avatarsContainerView.snp.remakeConstraints {
                $0.top.equalTo(headerView.snp.bottom).offset(16)
                $0.leading.equalToSuperview().inset(16)
                $0.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(avatarSize)
                $0.bottom.equalToSuperview().inset(20)
                $0.trailing.greaterThanOrEqualTo(last.snp.trailing)
            }
        }
    }
    
    private func clearAvatars() {
        avatarImageViews.forEach { $0.removeFromSuperview() }
        avatarImageViews.removeAll()
    }
}
