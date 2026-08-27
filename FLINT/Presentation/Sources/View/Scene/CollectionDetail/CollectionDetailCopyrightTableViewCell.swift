//
//  CollectionDetailCopyrightTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import UIKit

import SnapKit
import Then

public final class CollectionDetailCopyrightTableViewCell: BaseTableViewCell {

    // MARK: - Component

    private let copyrightLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(
            .body2_r_14,
            text: "Flint에서 제공하는 영화 · 드라마를 포함한 모든 콘텐츠의 저작권은 각 권리자에게 있으며, 관련 법령에 따라 보호됩니다. 컬렉션 이용 시 저작권을 준수해 주세요.",
            color: .flintGray300,
            lineBreakMode: .byWordWrapping,
            lineBreakStrategy: .hangulWordPriority
        )
    }

    // MARK: - Setup

    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .flintGray800
        selectionStyle = .none
    }

    public override func setHierarchy() {
        contentView.addSubview(copyrightLabel)
    }

    public override func setLayout() {
        copyrightLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
