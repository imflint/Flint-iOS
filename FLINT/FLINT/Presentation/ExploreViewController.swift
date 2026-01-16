//
//  ExploreViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit

import SnapKit
import Then

final class ExploreViewController: BaseViewController<UIView> {

    private let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.head1_sb_22, text: "explore")
        $0.textAlignment = .center
    }

    override func setUI() {
        view.backgroundColor = .systemBackground
    }

    override func setHierarchy() {
        view.addSubview(titleLabel)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
