//
//  PreferenceRankedChipTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class PreferenceRankedChipTableViewCell: BaseTableViewCell {

    private let chipView = PreferenceRankedChipView()

    override func setStyle() {
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none

        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        contentView.layoutMargins = .zero
    }

    override func setHierarchy() {
        contentView.addSubview(chipView)
    }

    override func setLayout() {
        chipView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        chipView.configure(keywords: [])
    }

    func configure(keywords: [KeywordDTO]) {
        chipView.configure(keywords: keywords)
    }
}
