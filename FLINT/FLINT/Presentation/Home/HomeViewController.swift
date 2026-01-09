//
//  HomeViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: BaseViewController {

    private let titleLabel = UILabel().then {
        $0.text = "Home"
        $0.textColor = .flintPrimary100
        $0.textAlignment = .center
        $0.applyFontStyle(.head1_sb_22)
    }

    override func setUI() {
        view.backgroundColor = .flintBackground
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
