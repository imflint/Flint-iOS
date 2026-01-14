//
//  SavedContentItemView.swift
//  FLINT
//
//  Created by 소은 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class SavedContentItemView: BaseView {

    // MARK: - Mode

    enum Mode: Equatable {
        case ottShortcutBookmark
        case selectable(isSelected: Bool)
        case plain
    }

    // MARK: - Event

    var onTapBookmark: (() -> Void)?
    var onTapShortcut: (() -> Void)?
    var onTapCheckbox: ((Bool) -> Void)?

    // MARK: - Metric
    
    private var isBookmarked: Bool = false

    private enum Metric {
        static let posterSize = CGSize(width: 100, height: 150)
        
    }

    // MARK: - State

    private var mode: Mode = .ottShortcutBookmark
    private var infoTrailingConstraint: Constraint?

    // MARK: - UI

    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .flintGray100
    }

    private let ottLogoStripeView = OTTLogoStripeView().then {
        $0.isHidden = true
    }

    private let infoContainerView = UIView()

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }

    private let directorLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    private let yearLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    private let shortcutButton = UIButton(type: .system).then {
        $0.contentHorizontalAlignment = .leading
        $0.isHidden = true

//        $0.contentEdgeInsets = .zero
//        $0.titleEdgeInsets = .zero

        if #available(iOS 15.0, *) {
            $0.configuration = nil
        }
    }


    private let bookmarkView = BookmarkView().then {
        $0.isHidden = true
    }

    private let checkboxButton = UIButton(type: .system).then {
        $0.tintColor = .clear
        $0.setImage(UIImage.icCheckboxEmpty.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.isHidden = true
    }

    // MARK: - BaseView

    override func setUI() {
        addSubviews(posterImageView, infoContainerView)

        infoContainerView.addSubviews(titleLabel, directorLabel, yearLabel, shortcutButton)

        addSubviews(bookmarkView,checkboxButton)

        posterImageView.addSubview(ottLogoStripeView)
        
        bookmarkView.onTap = { [weak self] isBookmarked in
            self?.onTapBookmark?()
        }
        shortcutButton.addTarget(self, action: #selector(didTapShortcut), for: .touchUpInside)
        checkboxButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
    }

    override func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }

        ottLogoStripeView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }

        infoContainerView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.bottom.equalToSuperview()

            infoTrailingConstraint = $0.trailing.equalToSuperview().inset(12).constraint
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        directorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        yearLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview()
        }

        shortcutButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bookmarkView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalToSuperview().inset(12)
        }

        checkboxButton.snp.remakeConstraints {
            $0.centerY.equalTo(posterImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(48)
        }
    }

    // MARK: - Configure

    struct ViewModel {
        let posterImage: UIImage?
        let title: String
        let director: String
        let year: String
        let isOTTDisplayEligible: Bool


        let isBookmarked: Bool
        let bookmarkCount: Int?
        let leadingPlatforms: [CircleOTTPlatform]?
        let remainingPlatformCount: Int?

        init(
            posterImage: UIImage?,
            title: String,
            director: String,
            year: String,
            isOTTDisplayEligible: Bool = true,
            isBookmarked: Bool = false,
            bookmarkCount: Int? = nil,
            leadingPlatforms: [CircleOTTPlatform]? = nil,
            remainingPlatformCount: Int? = nil
        ) {
            self.posterImage = posterImage
            self.title = title
            self.director = director
            self.year = year
            self.isOTTDisplayEligible = isOTTDisplayEligible
            self.isBookmarked = isBookmarked
            self.bookmarkCount = bookmarkCount
            self.leadingPlatforms = leadingPlatforms
            self.remainingPlatformCount = remainingPlatformCount
        }
    }
    
    // MARK: - Configure

    func configure(model: ViewModel, mode: Mode) {
        self.mode = mode
        
        posterImageView.image = model.posterImage

        let titleStyle: UIFont.PretendardStyle

        switch mode {
        case .ottShortcutBookmark:
            titleStyle = .body1_m_16
        case .selectable, .plain:
            titleStyle = .head3_sb_18
        }
        
        let subsytleSyle: UIFont.PretendardStyle
        
        switch mode {
        case .ottShortcutBookmark:
            subsytleSyle = .caption1_m_12
        case .selectable, .plain:
            subsytleSyle = .body1_r_16
        }

        titleLabel.attributedText = .pretendard(titleStyle, text: model.title, color: .flintWhite)
        directorLabel.attributedText = .pretendard(subsytleSyle, text: model.director, color: .flintGray300)
        yearLabel.attributedText = .pretendard(subsytleSyle, text: model.year, color: .flintGray300)
        shortcutButton.configuration = nil
        shortcutButton.setAttributedTitle(
            .pretendard(.body2_m_14, text: "작품 보러가기 >", color: .flintWhite),
            for: .normal
        )

        bookmarkView.configure(
            isBookmarked: model.isBookmarked,
            countText: model.bookmarkCount.map { "\($0)" }
        )

        if let platforms = model.leadingPlatforms {
            let remaining = model.remainingPlatformCount ?? 0
            ottLogoStripeView.configure(leading: platforms, remainingCount: remaining)
        } else {
            ottLogoStripeView.isHidden = true
        }
        
        updateShortcutAvailability(model: model)
        applyMode(mode)
    }

    // MARK: - apply

    private func applyMode(_ mode: Mode) {
        ottLogoStripeView.isHidden = true
        shortcutButton.isHidden = true
        bookmarkView.isHidden = true
        checkboxButton.isHidden = true

        switch mode {
        case .ottShortcutBookmark:
            ottLogoStripeView.isHidden = false
            shortcutButton.isHidden = false
            bookmarkView.isHidden = false

            infoTrailingConstraint?.deactivate()
            infoContainerView.snp.makeConstraints {
                infoTrailingConstraint = $0.trailing
                    .equalTo(bookmarkView.snp.leading)
                    .offset(-4)
                    .constraint
            }

        case let .selectable(isSelected):
            checkboxButton.isHidden = false
            updateCheckbox(isSelected: isSelected)

            infoTrailingConstraint?.deactivate()
            infoContainerView.snp.makeConstraints {
                infoTrailingConstraint = $0.trailing.equalTo(checkboxButton.snp.leading).offset(-4).constraint
                    $0.top.bottom.equalToSuperview().inset(24)
            }

        case .plain:
            infoTrailingConstraint?.deactivate()
            infoContainerView.snp.makeConstraints {
                infoTrailingConstraint = $0.trailing.equalToSuperview().inset(12).constraint
                $0.top.bottom.equalToSuperview().inset(24)
            }
        }
    }

    private func updateCheckbox(isSelected: Bool) {
        let image = isSelected ? UIImage.icCheckboxFill : UIImage.icCheckboxEmpty
        checkboxButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func updateShortcutAvailability(model: ViewModel) {
        let hasOTT = !(model.leadingPlatforms?.isEmpty ?? true) || (model.remainingPlatformCount ?? 0) > 0
        let isEnabled = hasOTT && model.isOTTDisplayEligible

        shortcutButton.isEnabled = isEnabled
        shortcutButton.alpha = isEnabled ? 1.0 : 0
    }


    // MARK: - Actions

    @objc private func didTapShortcut() {
        onTapShortcut?()
    }

    @objc private func didTapCheckbox() {
        guard case let .selectable(isSelected) = mode else { return }
        let newSelected = !isSelected
        self.mode = .selectable(isSelected: newSelected)
        updateCheckbox(isSelected: newSelected)
        onTapCheckbox?(newSelected)
    }
}
