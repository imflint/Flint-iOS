//
//  CreateCollectionHeaderImageCell.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

public final class CreateCollectionHeaderImageCell: BaseTableViewCell {
    
    public var onTapAddPhoto: (() -> Void)?
    public var onTapSelectPhoto: (() -> Void)?
    public var onTapDeletePhoto: (() -> Void)?
    
    private let headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = .imgBackgroundGradiantMiddle
    }
    
    private let blackOverlayView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
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
        contentView.addSubviews(headerImageView, blackOverlayView, addPhotoButton)
    }
    
    public override func setLayout() {
        headerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        blackOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
    
    public func configure(with image: UIImage?) {
        headerImageView.image = image ?? .imgBackgroundGradiantMiddle
    }
    
    @objc private func didTapAddPhoto() {
        onTapAddPhoto?()
    }
}
