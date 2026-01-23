//
//  TitleHeaderTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

public final class TitleHeaderTableViewCell: BaseTableViewCell {
    
    // MARK: - Type
    
    public enum TitleHeaderStyle {
        case normal
        case more
    }
    
    // MARK: - Public Event
    
    public var onTapMore: (() -> Void)?
    
    // MARK: - UI
    
    private let middleGuideView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 1
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textColor = .flintGray200
        $0.numberOfLines = 1
    }
    
    let moreButton = UIButton().then {
        $0.setImage(.icMore, for: .normal)
        $0.isHidden = true
    }
    
    // MARK: - Override
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(titleLabel, subtitleLabel, moreButton, middleGuideView)
        setAction()
    }
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        middleGuideView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(subtitleLabel.snp.top)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(1)
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(middleGuideView.snp.centerY)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    
    public override func prepare() {
        titleLabel.attributedText = nil
        subtitleLabel.attributedText = nil
        moreButton.isHidden = true
        onTapMore = nil
    }
    
    // MARK: - Action
    
    private func setAction() {
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    @objc private func didTapMore() {
        onTapMore?()
    }
    
    // MARK: - Configure
    
    public func configure(style: TitleHeaderStyle, title: String, subtitle: String) {
        moreButton.isHidden = (style != .more)
        
        titleLabel.attributedText = .pretendard(.head3_sb_18, text: title)
        subtitleLabel.attributedText = .pretendard(.body2_r_14, text: subtitle, color: .flintGray200)
    }
}
