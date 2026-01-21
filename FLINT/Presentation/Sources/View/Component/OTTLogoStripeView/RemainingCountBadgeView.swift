//
//  RemaingCountBadgeView.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit
import Then

public final class RemainingCountBadgeView: BaseView {
    
    //MARK: - Property
    
    private enum Metric {
        static let size: CGFloat = 28
    }
    
    //MARK: - Component
    
    private let label = UILabel().then {
        $0.textAlignment = .center
    }
    
    //MARK: - Setup
    
    public override func setUI() {
        backgroundColor = .flintGray500
        layer.masksToBounds = true
    }

    public override func setHierarchy() {
        addSubview(label)
    }
    
    public override func setLayout() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(6)
        }
        snp.makeConstraints {
            $0.height.equalTo(Metric.size)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    //MARK: - configure
    
    public func configure(count: Int) {
        let text = "+\(count)"
        label.attributedText = .pretendard(.body2_m_14, text: text, color: .flintWhite)
    }
}
