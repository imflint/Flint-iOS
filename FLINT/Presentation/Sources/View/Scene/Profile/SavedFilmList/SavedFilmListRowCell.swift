//
//  SavedFilmListRowCell.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

import Entity

public final class SavedFilmListRowCell: BaseTableViewCell {

    // MARK: - Callback

    public var onTapOTT: (() -> Void)?
    public var onTapBookmark: ((Bool) -> Void)?

    // MARK: - UI

    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .flintGray700
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }

    private let yearLabel = UILabel()

    private let bookmarkView = BookmarkView()

    private let ottButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        var title = AttributedString("시청 가능한 OTT")
        title.font = UIFont.pretendard(.body2_r_14)
        title.foregroundColor = .flintGray200
        config.attributedTitle = title
        config.image = UIImage(resource: .icMore)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.contentInsets = .zero
        $0.configuration = config
        $0.tintColor = .flintGray200
        $0.contentHorizontalAlignment = .leading
    }

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ottButton.addTarget(self, action: #selector(didTapOTT), for: .touchUpInside)
        bookmarkView.onTap = { [weak self] isBookmarked, _ in
            self?.onTapBookmark?(isBookmarked)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none
    }

    public override func setHierarchy() {
        contentView.addSubviews(posterImageView, titleLabel, yearLabel, bookmarkView, ottButton)
    }

    public override func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }

        bookmarkView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(14)
            $0.trailing.lessThanOrEqualTo(bookmarkView.snp.leading).offset(-12)
        }

        yearLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
        }

        ottButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(posterImageView.snp.bottom)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        titleLabel.attributedText = nil
        yearLabel.attributedText = nil
        onTapOTT = nil
        onTapBookmark = nil
    }

    // MARK: - Action

    @objc private func didTapOTT() {
        onTapOTT?()
    }

    // MARK: - Configure

    public func configure(with item: ContentInfoEntity) {
        if let url = URL(string: item.imageUrl) {
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = nil
        }

        titleLabel.attributedText = .pretendard(
            .body1_b_16,
            text: item.title,
            color: .flintWhite,
            lineBreakMode: .byTruncatingTail
        )

        yearLabel.attributedText = .pretendard(
            .body2_r_14,
            text: "\(item.year)",
            color: .flintGray300
        )

        ottButton.isHidden = item.ottList.isEmpty
        // 저장 리스트에 있는 작품은 모두 저장 상태 + 서버 카운트 정보가 없어 숨김
        bookmarkView.configure(isBookmarked: true, countText: nil)
    }
}
