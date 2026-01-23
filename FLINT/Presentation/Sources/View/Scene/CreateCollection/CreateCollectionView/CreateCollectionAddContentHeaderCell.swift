//
//  CreateCollectionAddContentHeaderCell.swift
//  FLINT
//

import UIKit

import SnapKit
import Then

public final class CreateCollectionAddContentHeaderCell: BaseTableViewCell {

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = .pretendard(.head3_m_18, text: "작품 추가", color: .flintWhite)
    }

    private let subtitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = .pretendard(.body2_r_14, text: "작품을 2개 이상 추가해주세요.", color: .flintGray300)
    }

    private let countLabel = UILabel().then {
        $0.textAlignment = .right
        $0.attributedText = .pretendard(.caption1_m_12, text: "0/10", color: .flintWhite)
    }

    // MARK: - Setup

    public override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none
    }

    public override func setHierarchy() {
        contentView.addSubviews(titleLabel, subtitleLabel, countLabel)
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(countLabel.snp.leading).offset(-12)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(countLabel.snp.leading).offset(-12)
            $0.bottom.equalToSuperview().inset(16)
        }

        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(subtitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    public override func prepare() {}

    // MARK: - Configure

    public func configure(selectedCount: Int, maxCount: Int = 10) {
        countLabel.attributedText = .pretendard(
            .caption1_m_12,
            text: "\(selectedCount)/\(maxCount)",
            color: .flintWhite
        )
    }
}
