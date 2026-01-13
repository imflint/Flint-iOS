//
//  RemaingCountBadgeView.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class RemainingCountBadgeView: BaseView {
    
    //MARK: - private
    
    private enum Metric {
        static let size: CGFloat = 28
    }
    
    private let label = UILabel().then {
        $0.textAlignment = .center
    }
    
    //MARK: - override
    
    override func setUI() {
        backgroundColor = .flintGray500
        layer.masksToBounds = true
    }

    override func setHierarchy() {
        addSubview(label)
    }
    
    override func setLayout() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(6)
        }
        snp.makeConstraints {
            $0.height.equalTo(Metric.size)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    //MARK: - configure
    
    func configure(count: Int) {
        let text = "+\(count)"
        label.attributedText = .pretendard(.body2_m_14, text: text, color: .flintWhite)
    }
}
