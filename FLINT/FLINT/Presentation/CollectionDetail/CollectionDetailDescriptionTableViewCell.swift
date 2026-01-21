//
//  CollectionDetailDescriptionTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class CollectionDetailDescriptionTableViewCell: BaseTableViewCell {

    // MARK: - Callback
    
     var onTapAuthor: (() -> Void)?

    // MARK: - Component

    private let containerView = UIView().then {
        $0.backgroundColor = .flintBackground
    }

    private let headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }

    private let authorLabel = UILabel().then {
        $0.textColor = .white
        $0.attributedText = .pretendard(.head2_sb_20, text: "쏘나기")
    }

    private let verifiedBadgeImageView = UIImageView().then {
        $0.image = UIImage(resource: .icQuilified)
        $0.contentMode = .scaleAspectFit
    }

    private let dateLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.font = .pretendard(.body2_m_14)
        $0.attributedText = .pretendard(.body2_m_14, text: "2026.01.20")
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = .flintGray300
    }

    private let descriptionLabel = UILabel().then {
        $0.textColor = .flintGray100
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(.body1_r_16, text: "시간이 흘러도 빛이 바래지 않는, 사랑의 미묘한 온도를 담은 제 최애 영화 모음집입니다", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
    }

    // MARK: - Init / Bind

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Override

    override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    override func setHierarchy() {
        contentView.addSubview(containerView)

        containerView.addSubview(headerStackView)
        headerStackView.addArrangedSubviews(authorLabel, verifiedBadgeImageView, dateLabel)

        containerView.addSubviews(dividerView, descriptionLabel)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
        }

        verifiedBadgeImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        dateLabel.text = nil
        descriptionLabel.text = nil
        verifiedBadgeImageView.isHidden = false
    }

    // MARK: - Configure

    func configure(
        author: String,
        isVerified: Bool,
        dateText: String,
        description: String
    ) {
        authorLabel.text = author
        verifiedBadgeImageView.isHidden = !isVerified
        dateLabel.text = dateText
        descriptionLabel.text = description
    }
}
