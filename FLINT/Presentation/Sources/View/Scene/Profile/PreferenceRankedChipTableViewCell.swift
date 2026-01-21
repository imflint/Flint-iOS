//
//  PreferenceRankedChipTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/20/26.
//

import UIKit

import SnapKit
import Then

public final class PreferenceRankedChipTableViewCell: BaseTableViewCell {

    private let chipView = PreferenceRankedChipView()

    public override func setStyle() {
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none

        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        contentView.layoutMargins = .zero
    }

    public override func setHierarchy() {
        contentView.addSubview(chipView)
    }

    public override func setLayout() {
        chipView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        chipView.configure(keywords: [])
    }

    public func configure(keywords: [KeywordDTO]) {
        chipView.configure(keywords: keywords)
    }
}
