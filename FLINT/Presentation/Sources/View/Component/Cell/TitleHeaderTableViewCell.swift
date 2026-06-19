//
//  TitleHeaderTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

public final class TitleHeaderTableViewCell: BaseTableViewCell {

    // MARK: - Type

    public enum TitleHeaderStyle {
        case normal
        case more
    }

    // MARK: - Public Event

    public var onTapMore: (() -> Void)?

    // MARK: - UI

    private let middleGuideView = UIView()

    private let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 1
    }

    private let subtitleLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.numberOfLines = 1
    }

    private let subtitleStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }

    private let infoIconImageView = UIImageView().then {
        $0.image = UIImage(resource: .icInfo)
        $0.tintColor = .flintGray200
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    let moreButton = UIButton().then {
        $0.setImage(.icMore, for: .normal)
        $0.isHidden = true
    }

    // MARK: - Override

    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    public override func setHierarchy() {
        contentView.addSubviews(titleLabel, subtitleStack, moreButton, middleGuideView)
        subtitleStack.addArrangedSubviews(subtitleLabel, infoIconImageView)
        setAction()
    }
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        subtitleStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().inset(24)
        }

        infoIconImageView.snp.makeConstraints {
            $0.size.equalTo(19)
        }

        middleGuideView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(subtitleStack.snp.top)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(1)
        }

        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(middleGuideView.snp.centerY)
            $0.trailing.equalToSuperview().inset(12)
        }
    }


    public override func prepare() {
        titleLabel.attributedText = nil
        subtitleLabel.attributedText = nil
        moreButton.isHidden = true
        infoIconImageView.isHidden = true
        onTapMore = nil
    }

    // MARK: - Action

    private func setAction() {
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }

    @objc private func didTapMore() {
        onTapMore?()
    }

    // MARK: - Configure

    public func configure(style: TitleHeaderStyle, title: String, subtitle: String, showInfo: Bool = false) {
        moreButton.isHidden = (style != .more)
        infoIconImageView.isHidden = !showInfo

        titleLabel.attributedText = .pretendard(.head3_sb_18, text: title)
        subtitleLabel.attributedText = .pretendard(.body2_r_14, text: subtitle, color: .flintGray200)
    }
}
