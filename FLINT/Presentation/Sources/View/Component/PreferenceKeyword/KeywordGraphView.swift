//
//  KeywordGraphView.swift
//  FLINT
//
//  Created by 진소은 on 6/16/26.
//

import UIKit

import SnapKit
import Then

import Domain

public final class KeywordGraphView: BaseView {

    private enum Metric {
        static let rowSpacing: CGFloat = 12
        static let dotSize: CGFloat = 12
        static let dotToNameSpacing: CGFloat = 8
        static let barWidth: CGFloat = 160
        static let barHeight: CGFloat = 12
        static let barToPercentSpacing: CGFloat = 12
        static let topThreeCount = 3
    }

    private let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Metric.rowSpacing
        $0.alignment = .fill
        $0.distribution = .fill
    }

    public override func setHierarchy() {
        addSubview(vStack)
    }

    public override func setLayout() {
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func configure(keywords: [KeywordEntity]) {
        vStack.arrangedSubviews.forEach {
            vStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let topThree = keywords.sorted { $0.rank < $1.rank }.prefix(Metric.topThreeCount)
        topThree.forEach { keyword in
            let row = KeywordGraphRowView()
            row.configure(keyword: keyword)
            vStack.addArrangedSubview(row)
        }
    }
}

private final class KeywordGraphRowView: BaseView {

    private enum Metric {
        static let dotSize: CGFloat = 12
        static let dotToNameSpacing: CGFloat = 8
        static let barWidth: CGFloat = 160
        static let barHeight: CGFloat = 12
        static let barToPercentSpacing: CGFloat = 12
        static let barCornerRadius: CGFloat = 4
    }

    private let dotView = UIView().then {
        $0.layer.cornerRadius = Metric.dotSize / 2
        $0.layer.masksToBounds = true
    }

    private let nameLabel = UILabel()
    private let percentLabel = UILabel()

    private let barContainerView = UIView().then {
        $0.backgroundColor = UIColor.flintGray500.withAlphaComponent(0.3)
        $0.layer.cornerRadius = Metric.barCornerRadius
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
    }

    private let barFillView = GradientView().then {
        $0.startPoint = CGPoint(x: 0, y: 0.5)
        $0.endPoint = CGPoint(x: 1, y: 0.5)
        $0.layer.cornerRadius = Metric.barCornerRadius
        $0.layer.masksToBounds = true
    }

    private let topHighlightView = GradientView().then {
        $0.colors = [UIColor.white.withAlphaComponent(0.25), .clear]
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
        $0.isUserInteractionEnabled = false
    }

    private var barFillWidthConstraint: Constraint?

    override func setHierarchy() {
        addSubviews(dotView, nameLabel, barContainerView, percentLabel)
        barContainerView.addSubviews(barFillView, topHighlightView)
    }

    override func setLayout() {
        dotView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metric.dotSize)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(dotView.snp.trailing).offset(Metric.dotToNameSpacing)
            $0.centerY.equalToSuperview()
        }

        percentLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }

        barContainerView.snp.makeConstraints {
            $0.trailing.equalTo(percentLabel.snp.leading).offset(-Metric.barToPercentSpacing)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Metric.barWidth)
            $0.height.equalTo(Metric.barHeight)
        }

        barFillView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            barFillWidthConstraint = $0.width.equalTo(0).constraint
        }

        topHighlightView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(keyword: KeywordEntity) {
        let color = Self.uiColor(for: keyword.color)

        dotView.backgroundColor = color
        nameLabel.attributedText = .pretendard(.body1_m_16, text: keyword.name, color: .white)
        percentLabel.attributedText = .pretendard(.body1_m_16, text: "\(keyword.percentage)%", color: .white)

        barFillView.colors = [color.withAlphaComponent(0.2), color]

        let clampedPercent = max(0, min(100, keyword.percentage))
        let width = Metric.barWidth * CGFloat(clampedPercent) / 100.0
        barFillWidthConstraint?.update(offset: width)
    }

    private static func uiColor(for keywordColor: KeywordColor) -> UIColor {
        switch keywordColor {
        case .blue: return .flintBlue
        case .pink: return .flintPink
        case .green: return .flintGreen
        case .orange: return .flintOrange
        case .yellow: return .flintYellow
        }
    }
}
