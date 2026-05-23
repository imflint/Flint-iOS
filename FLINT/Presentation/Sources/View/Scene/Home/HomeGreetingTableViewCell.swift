//
//  HomeGreetingTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

public final class HomeGreetingTableViewCell: BaseTableViewCell {
    
    // MARK: - UI
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage.imgBackgroundHeader
    }
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystem.Icon.flintLogo
    }
    
    private let greetingLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(backgroundImageView, logoImageView, greetingLabel)
    }
    
    public override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.size.equalTo(CGSize(width: 90, height: 20))
        }
               
        
        greetingLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Configure
    
    public func configure(userName: String) {
        greetingLabel.attributedText = .pretendard(
            .head1_sb_22,
            text: "반가워요, \(userName) 님\n오늘은 어떤 작품이 끌리세요?",
            color: .flintWhite
        )
    }
    
    public override func prepare() {
        greetingLabel.text = nil
    }
}
