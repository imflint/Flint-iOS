//
//  SettingMenuCell.swift
//  Presentation
//
//  Created by 소은 on 5/2/26.
//

import UIKit

import SnapKit
import Then

// MARK: - SettingMenuCell

public final class SettingMenuCell: BaseTableViewCell {
    
    public static let identifier = "SettingMenuCell"
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Configuration
    
    public func configure(with title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Highlight
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.2) {
            self.contentView.backgroundColor = highlighted ? UIColor.white.withAlphaComponent(0.05) : .clear
        }
    }
}
