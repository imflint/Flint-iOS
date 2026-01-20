//
//  MyViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit
import SnapKit
import Then

public final class MyViewController: BaseViewController<UIView> {

    private let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.head1_sb_22, text: "My")
        $0.textAlignment = .center
    }

    public override func setUI() {
        view.backgroundColor = .systemBackground
    }

    public override func setHierarchy() {
        view.addSubview(titleLabel)
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
