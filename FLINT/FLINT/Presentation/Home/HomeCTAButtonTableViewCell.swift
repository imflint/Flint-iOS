//
//  HomeCTAButtonTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

final class HomeCTAButtonTableViewCell: BaseTableViewCell {

    // MARK: - Event

    var onTap: (() -> Void)?

    // MARK: - UI

    private let button = FlintButton(style: .able, title: "취향 발견하러 가기").then {
        $0.isUserInteractionEnabled = true
    }

    // MARK: - BaseTableViewCell

    override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    override func setHierarchy() {
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    override func setLayout() {
        button.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

    override func prepare() {
        super.prepare()
        onTap = nil
    }

    // MARK: - Configure

    func configure(title: String) {
        button.title = title

    }

    // MARK: - Action

    @objc private func didTap() {
        onTap?()
    }
}
