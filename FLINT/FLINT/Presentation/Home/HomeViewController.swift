//
//  HomeViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: BaseViewController<UIView> {

    private let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.head1_sb_22, text: "Home")
        $0.textColor = .flintPrimary100
        $0.textAlignment = .center
    }

    override func setUI() {
        view.backgroundColor = .flintError200
        
        setNavigationBar(.init(left: .logo, title: "asdf", right: .text(title: "건너뛰기", color: .flintError500), backgroundStyle: .clear))
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
