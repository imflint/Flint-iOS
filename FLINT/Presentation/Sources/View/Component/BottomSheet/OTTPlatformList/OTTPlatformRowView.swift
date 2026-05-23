//
//  OTTPlatformRowView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

import Domain

public final class OTTPlatformRowView: BaseView {
    
    // MARK: - Public Event
    
    public var onTap: (() -> Void)?
    
    // MARK: - UI
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    // MARK: - Public API
    
    public func configure(platform: OTTPlatform) {
        iconImageView.image = platform.icon
        titleLabel.attributedText = .pretendard(.body1_sb_16, text: platform.title, color: .flintWhite)
    }
    
    // MARK: - BaseView
    
    public override func setUI() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    public override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Action
    
    @objc private func didTap() {
        onTap?()
    }
}
