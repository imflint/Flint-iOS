//
//  HomeGreetingTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

final class HomeGreetingTableViewCell: BaseTableViewCell {
    
    // MARK: - UI
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    private let greetingLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    // MARK: - Setup
    
    override func setHierarchy() {
        contentView.addSubviews(backgroundImageView)
        contentView.addSubviews(greetingLabel)
        
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        greetingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(174)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        backgroundImageView.image = UIImage.imgBackgroundGradiantMiddle
    }
    
    // MARK: - Configure
    
    func configure(userName: String) {
        greetingLabel.attributedText = .pretendard(
                    .head1_sb_22,
                    text: "반가워요, \(userName) 님\n오늘은 어떤 작품이 끌리세요?",
                    color: .flintWhite
                )
    }
    
    //TODO: - 지워도되려나?!
    override func prepare() {
        greetingLabel.text = nil
    }
}
