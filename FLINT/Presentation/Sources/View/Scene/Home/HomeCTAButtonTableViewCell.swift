//
//  HomeCTAButtonTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

public final class HomeCTAButtonTableViewCell: BaseTableViewCell {

    // MARK: - Event

    public var onTap: (() -> Void)?

    // MARK: - UI

    private let button = FlintButton(style: .able, title: "취향 발견하러 가기").then {
        $0.isUserInteractionEnabled = true
    }

    // MARK: - BaseTableViewCell

    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    public override func setHierarchy() {
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    public override func setLayout() {
        button.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

    public override func prepare() {
        super.prepare()
        onTap = nil
    }

    // MARK: - Configure

    public func configure(title: String) {
        button.title = title

    }

    // MARK: - Action

    @objc private func didTap() {
        onTap?()
    }
}
