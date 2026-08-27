//
//  CreateCollectionHeaderImageCell.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

import Kingfisher

public final class CreateCollectionHeaderImageCell: BaseTableViewCell {
    
    public var onTapAddPhoto: (() -> Void)?
    public var onTapSelectPhoto: (() -> Void)?
    public var onTapDeletePhoto: (() -> Void)?
    
    private let headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = .imgBackgroundGradiantMiddle
    }
    
    private let gradientView = GradientView().then {
        $0.colors = [
            UIColor.black.withAlphaComponent(0),
            UIColor.black.withAlphaComponent(0.8)
        ]
        $0.locations = [0.0, 1.0]
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
        $0.isUserInteractionEnabled = false
    }
    
    private let addPhotoButton = UIButton().then {
        $0.setImage(.icBackgroundPhoto, for: .normal)
    }
    
    public override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
        addPhotoButton.addTarget(self, action: #selector(didTapAddPhoto), for: .touchUpInside)
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(headerImageView, gradientView, addPhotoButton)
    }
    
    public override func setLayout() {
        headerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
    
    public func configure(with image: UIImage?) {
        headerImageView.kf.cancelDownloadTask()
        headerImageView.image = image ?? .imgBackgroundGradiantMiddle
    }

    public func configure(with imageURL: URL?) {
        headerImageView.kf.cancelDownloadTask()
        if let imageURL {
            headerImageView.kf.setImage(with: imageURL, placeholder: UIImage.imgBackgroundGradiantMiddle)
        } else {
            headerImageView.image = .imgBackgroundGradiantMiddle
        }
    }
    
    @objc private func didTapAddPhoto() {
        onTapAddPhoto?()
    }
}
