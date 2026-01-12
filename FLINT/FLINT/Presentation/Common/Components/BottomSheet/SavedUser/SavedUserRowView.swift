//
//  Untitled.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class SavedUserRowView: BaseView {

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22
    }

    private let nameLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.font = UIFont.pretendard(.body1_sb_16)
    }

    private let badgeImageView = UIImageView().then {
        $0.image = UIImage.icQuilified
        $0.isHidden = true
    }

    override func setUI() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(badgeImageView)
    }

    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }

        badgeImageView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }

        snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }

    func configure(user: SavedUserRowItem) {
        profileImageView.image = user.profileImage
        nameLabel.text = user.nickname
        badgeImageView.isHidden = !user.isVerified
    }
}
