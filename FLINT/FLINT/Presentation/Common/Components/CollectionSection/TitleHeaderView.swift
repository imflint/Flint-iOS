//
//  TitleHeader.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class TitleHeaderView: BaseView {

    // MARK: - UI
    
    private let titleHeaderView = TitleHeaderView()

    private let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.applyFontStyle(.head3_sb_18)
        $0.numberOfLines = 1
    }

    private let subtitleLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.applyFontStyle(.body2_r_14)
        $0.numberOfLines = 1
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        titleLabel.applyFontStyle(.head3_sb_18)
        
        subtitleLabel.text = subtitle
        subtitleLabel.applyFontStyle(.body2_r_14)
    }

    // MARK: - override

    override func setUI() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview()
        }
    }
}
