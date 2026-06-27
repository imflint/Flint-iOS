//
//  KeywordGraphTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 6/16/26.
//

import UIKit

import SnapKit
import Then

import Entity

public final class KeywordGraphTableViewCell: BaseTableViewCell {

    private let graphView = KeywordGraphView()

    public override func setStyle() {
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none
    }

    public override func setHierarchy() {
        contentView.addSubview(graphView)
    }

    public override func setLayout() {
        graphView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        graphView.configure(keywords: [])
    }

    public func configure(keywords: [KeywordEntity]) {
        graphView.configure(keywords: keywords)
    }
}
