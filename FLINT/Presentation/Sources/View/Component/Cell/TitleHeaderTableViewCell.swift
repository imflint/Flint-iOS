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
    public var onTapInfo: (() -> Void)?
    public var onTapRefresh: (() -> Void)?

    // MARK: - UI

    private let titleStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 1
    }

    private let infoButton = UIButton().then {
        $0.setImage(UIImage(resource: .icInfo), for: .normal)
        $0.tintColor = .flintWhite
        $0.isHidden = true
    }

    private let subtitleLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.numberOfLines = 1
    }

    private let middleGuideView = UIView()

    let moreButton = UIButton().then {
        $0.setImage(.icMore, for: .normal)
        $0.isHidden = true
    }

    private let refreshStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
        $0.isHidden = true
        $0.isUserInteractionEnabled = true
    }

    private let refreshIconImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_refresh", in: .module, with: nil)
        $0.tintColor = DesignSystem.Color.secondary400
        $0.contentMode = .scaleAspectFit
    }

    private let refreshLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private let tooltipView = UIView().then {
        $0.backgroundColor = DesignSystem.Color.gray800
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.isHidden = true
    }

    private let tooltipLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    // MARK: - Override

    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        clipsToBounds = false
        contentView.clipsToBounds = false
        layer.masksToBounds = false
        contentView.layer.masksToBounds = false
    }

    public override func setHierarchy() {
        contentView.addSubviews(titleStack, subtitleLabel, moreButton, refreshStack, tooltipView, middleGuideView)
        titleStack.addArrangedSubviews(titleLabel, infoButton)
        refreshStack.addArrangedSubviews(refreshIconImageView, refreshLabel)
        tooltipView.addSubview(tooltipLabel)
        setAction()
    }

    public override func setLayout() {
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(60)
        }

        infoButton.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(60)
            $0.bottom.equalToSuperview().inset(24)
        }

        middleGuideView.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom)
            $0.bottom.equalTo(subtitleLabel.snp.top)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(1)
        }

        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(middleGuideView.snp.centerY)
            $0.trailing.equalToSuperview().inset(12)
        }

        refreshIconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        refreshStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }

        tooltipView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(13)
        }

        tooltipLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }

    public override func prepare() {
        titleLabel.attributedText = nil
        subtitleLabel.attributedText = nil
        refreshLabel.attributedText = nil
        tooltipLabel.attributedText = nil
        moreButton.isHidden = true
        infoButton.isHidden = true
        refreshStack.isHidden = true
        tooltipView.isHidden = true
        layer.zPosition = 0
        onTapMore = nil
        onTapInfo = nil
        onTapRefresh = nil
    }

    // MARK: - Action

    private func setAction() {
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(didTapInfo), for: .touchUpInside)

        let refreshTap = UITapGestureRecognizer(target: self, action: #selector(didTapRefresh))
        refreshStack.addGestureRecognizer(refreshTap)
    }

    @objc private func didTapMore() {
        onTapMore?()
    }

    @objc private func didTapInfo() {
        onTapInfo?()
    }

    @objc private func didTapRefresh() {
        onTapRefresh?()
    }

    // MARK: - Configure

    public func configure(
        style: TitleHeaderStyle,
        title: String,
        subtitle: String,
        showInfo: Bool = false,
        showRefresh: Bool = false,
        isRefreshing: Bool = false,
        tooltipText: String? = nil
    ) {
        moreButton.isHidden = (style != .more)
        infoButton.isHidden = !showInfo
        refreshStack.isHidden = !showRefresh

        titleLabel.attributedText = .pretendard(.head3_sb_18, text: title)
        subtitleLabel.attributedText = .pretendard(.body2_r_14, text: subtitle, color: .flintGray200)
        refreshLabel.attributedText = .pretendard(
            .micro1_m_10,
            text: "업데이트",
            color: DesignSystem.Color.secondary400
        )

        if showRefresh && isRefreshing {
            startRefreshAnimationIfNeeded()
        } else {
            stopRefreshAnimation()
        }

        let showTooltip = tooltipText != nil
        tooltipView.isHidden = !showTooltip
        layer.zPosition = showTooltip ? 100 : 0
        if let text = tooltipText {
            tooltipLabel.attributedText = .pretendard(
                .body2_r_14,
                text: text,
                color: .flintGray300,
                lineBreakMode: .byWordWrapping,
                lineBreakStrategy: .hangulWordPriority
            )
        }
    }

    // MARK: - Refresh Animation

    private enum RefreshAnimation {
        static let key = "refreshRotation"
        static let duration: CFTimeInterval = 1.0
    }

    private func startRefreshAnimationIfNeeded() {
        guard refreshIconImageView.layer.animation(forKey: RefreshAnimation.key) == nil else { return }
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = RefreshAnimation.duration
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        refreshIconImageView.layer.add(rotation, forKey: RefreshAnimation.key)
    }

    private func stopRefreshAnimation() {
        refreshIconImageView.layer.removeAnimation(forKey: RefreshAnimation.key)
    }
}
