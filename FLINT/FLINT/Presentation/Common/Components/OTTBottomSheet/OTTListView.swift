//
//  OTTListView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class OTTListView: BaseView {
    
    static let rowHeight: CGFloat = 48
    static let rowSpacing: CGFloat = 8

    // MARK: - Public Event

    var onSelectPlatform: ((OTTPlatform) -> Void)?

    // MARK: - UI

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }

    // MARK: - Data

    private var platforms: [OTTPlatform] = []

    // MARK: - Public API

    func configure(platforms: [OTTPlatform]) {
        self.platforms = platforms
        rebuildRows()
    }

    // MARK: - BaseView

    override func setUI() {
        addSubview(stackView)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Private

    private func rebuildRows() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        platforms.forEach { platform in
            let row = OTTPlatformRowView()
            row.configure(platform: platform)
            row.onTapOpen = { [weak self] in
                self?.onSelectPlatform?(platform)
            }
            stackView.addArrangedSubview(row)
        }
    }
}
