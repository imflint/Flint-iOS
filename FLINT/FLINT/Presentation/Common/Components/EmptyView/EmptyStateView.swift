//
//  EmptyStateView.swift
//  FLINT
//
//  Created by 소은 on 1/8/26.
//

import UIKit

import SnapKit
import Then

// MARK: - EmptyStateView

final class EmptyStateView: BaseView {

    // MARK: - UI Components

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textColor = .flintWhite
    }

    // MARK: - Init

    init(type: EmptyStateType) {
        super.init(frame: .zero)
        apply(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func setHierarchy() {
        addSubviews(imageView, titleLabel)
    }

    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Public

    func apply(type: EmptyStateType) {
        imageView.image = type.image

        titleLabel.attributedText = .pretendard(.body1_b_16, text: type.title, alignment: .center)
    }
}
