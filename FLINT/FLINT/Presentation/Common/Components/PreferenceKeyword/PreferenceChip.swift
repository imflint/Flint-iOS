//
//  PreferenceChip.swift
//  FLINT
//
//  Created by 진소은 on 1/17/26.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class PreferenceChip: BaseView {

// MARK: - Component

    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }

    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private let keywordLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    // MARK: - State

    private var style: PreferenceChipStyle = .gray {
        didSet {
            applyStyleConstraints()
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - BaseView

    override func setHierarchy() {
        contentStackView.addArrangedSubviews(iconImageView, keywordLabel)
        addSubviews(backgroundImageView, contentStackView)
    }

    override func setLayout() {
        applyStyleConstraints()
    }

    override var intrinsicContentSize: CGSize {
        let content = contentStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = content.width + style.hInset * 2
        return CGSize(width: width, height: style.height)
    }

    // MARK: - Public

    func configure(dto: KeywordDTO) {
        style = PreferenceChipStyle.from(rank: dto.rank, color: dto.color)

        keywordLabel.attributedText = .pretendard(.head2_m_20, text: dto.name, color: .white)

        applyResizableBackground(style.backgroundImage(for: dto.color))

        contentStackView.spacing = style.spacing
        iconImageView.isHidden = (style.iconSize == 0)

        if style.iconSize == 0 {
            iconImageView.kf.cancelDownloadTask()
            iconImageView.image = nil
        } else {
            if let url = URL(string: dto.imageUrl) {
                iconImageView.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [.transition(.fade(0.15)), .cacheOriginalImage]
                )
            } else {
                iconImageView.image = nil
            }
        }

        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    // MARK: - Private

    private func applyStyleConstraints() {
        backgroundImageView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(style.height)
        }

        iconImageView.snp.remakeConstraints {
            $0.size.equalTo(style.iconSize)
        }

        contentStackView.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(style.hInset)
            $0.trailing.equalToSuperview().inset(style.hInset)
            $0.top.equalToSuperview().inset(style.vInset)
            $0.bottom.equalToSuperview().inset(style.vInset)
        }
    }

    private func applyResizableBackground(_ baseImage: UIImage) {
        let base = baseImage.withRenderingMode(.alwaysOriginal)
        let cap = base.size.height / 2

        backgroundImageView.image = base.resizableImage(
            withCapInsets: UIEdgeInsets(top: 0, left: cap, bottom: 0, right: cap),
            resizingMode: .stretch
        )
    }
}
