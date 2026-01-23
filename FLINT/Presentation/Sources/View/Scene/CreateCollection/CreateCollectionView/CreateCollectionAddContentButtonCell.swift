//
//  CreateCollectionAddContentButtonView.swift
//  Presentation
//
//  Created by 소은 on 1/23/26.
//

import UIKit

import SnapKit
import Then

public final class CreateCollectionAddContentButtonCell: BaseTableViewCell {

    // MARK: - Event

    public var onTapAdd: (() -> Void)?

    // MARK: - UI

    private let addButton = FlintButton(
        style: .colorOutline,
        title: "작품 추가하기",
        image: .icPlus
    )

    // MARK: - Setup

    public override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none
    }

    public override func setHierarchy() {
        contentView.addSubview(addButton)
        setAction()
    }

    public override func setLayout() {
        addButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(36)
            $0.height.equalTo(80)
        }
    }

    public override func prepare() {
        onTapAdd = nil
    }
}

// MARK: - Action

private extension CreateCollectionAddContentButtonCell {

    func setAction() {
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    }

    @objc func didTapAdd() {
        onTapAdd?()
    }
}
