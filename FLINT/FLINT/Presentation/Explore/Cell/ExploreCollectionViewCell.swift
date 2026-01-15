//
//  ExploreCollectionViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.15.
//

import UIKit

import SnapKit
import Then
import Network

class ExploreCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Component
    
    let collectionImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let gradientView = GradientView().then {
        $0.colors = [.clear, .clear, UIColor(hex: 0x000000, alpha: 0.8)]
        $0.locations = [0, 0.35, 1]
        $0.startPoint = .init(x: 0.5, y: 0.0)
        $0.endPoint = .init(x: 0.5, y: 1.0)
    }
    
    let collectionDetailButton = FlintButton(style: .colorOutline, title: "이 컬렉션 보러가기")
    
    let collectionTitleLabel = UILabel().then {
        $0.textColor = .flintWhite
    }
    let collectionDescriptionLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 0
    }
    
    // MARK: - Basic
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setHierarchy() {
        addSubviews(
            collectionImageView,
            gradientView,
            collectionDetailButton,
            collectionDescriptionLabel,
            collectionTitleLabel,
        )
    }
    
    override func setLayout() {
        collectionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collectionDetailButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        collectionDescriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(collectionDetailButton.snp.top).offset(-28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        collectionTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(collectionDescriptionLabel.snp.top).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func prepare() {
        collectionImageView.image = nil
        collectionTitleLabel.text = nil
        collectionDescriptionLabel.text = nil
    }
}
