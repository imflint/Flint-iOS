//
//  RecentCollectionCell.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class RecentCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "RecentCollectionCell"

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let bottomOverlayView = UIView().then {
        $0.backgroundColor = .flintOverlay
    }

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .flintGray50
        $0.numberOfLines = 1
        $0.applyFontStyle(.body2_m_14)
    }

    private let userNameLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.numberOfLines = 1
        $0.applyFontStyle(.caption1_r_12)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    private func setUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(bottomOverlayView)
        bottomOverlayView.addSubview(profileImageView)
        bottomOverlayView.addSubview(titleLabel)
        bottomOverlayView.addSubview(userNameLabel)
    }

    private func setLayout() {
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        bottomOverlayView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(32)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalTo(profileImageView.snp.centerY).offset(-1)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(profileImageView.snp.centerY).offset(1) 
        }
    }

    func configure(with item: RecentCollectionItemViewData) {
        imageView.image = item.image
        titleLabel.text = item.title
        userNameLabel.text = item.userName
        profileImageView.image = item.profileImage
    }
}
