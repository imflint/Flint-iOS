//
//  PreferenceRankedChipView.swift
//  FLINT
//
//  Created by 진소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class PreferenceRankedChipView: BaseView {

    private let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.alignment = .fill
        $0.distribution = .fill
    }

    override func setHierarchy() {
        addSubview(vStack)
    }

    override func setLayout() {
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(keywords: [KeywordDTO]) {
        let byRank = Dictionary(uniqueKeysWithValues: keywords.map { ($0.rank, $0) })

        let sumA = [1, 2, 4].compactMap { byRank[$0]?.name.count }.reduce(0, +)
        let sumB = [3, 5, 6].compactMap { byRank[$0]?.name.count }.reduce(0, +)
        let useTwoRows = (sumA <= 6 && sumB <= 6)

        let orderedRanks: [Int] = useTwoRows
        ? [1, 4, 2, 5, 3, 6]
        : [1, 4, 5, 2, 3, 6]

        let validRanks = orderedRanks.filter { byRank[$0] != nil }

        let rows: [[Int]]
        if useTwoRows {
            rows = [
                Array(validRanks.prefix(3)),
                Array(validRanks.dropFirst(3).prefix(3))
            ]
        } else {
            rows = [
                Array(validRanks.prefix(2)),
                Array(validRanks.dropFirst(2).prefix(2)),
                Array(validRanks.dropFirst(4).prefix(2))
            ]
        }

        vStack.arrangedSubviews.forEach {
            vStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let spacing: CGFloat = useTwoRows ? 8 : 12

        rows.forEach { rankRow in
            let rowContainer = makeRowContainer(rowSpacing: spacing)

            let rowStack = rowContainer.subviews.first as! UIStackView
            rankRow.forEach { r in
                guard let dto = byRank[r] else { return }
                let chip = PreferenceChip()
                chip.configure(dto: dto)
                rowStack.addArrangedSubview(chip)
            }

            vStack.addArrangedSubview(rowContainer)
        }
    }

    // MARK: - Row Container

    private func makeRowContainer(rowSpacing: CGFloat) -> UIView {
        let container = UIView()

        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.alignment = .center
        rowStack.distribution = .fill
        rowStack.spacing = rowSpacing

        container.addSubview(rowStack)

        rowStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }

        return container
    }
}
