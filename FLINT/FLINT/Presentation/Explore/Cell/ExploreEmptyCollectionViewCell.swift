//
//  ExploreEmptyCollectionViewCell.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.16.
//

import UIKit

import SnapKit
import Then

class ExploreEmptyCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Component
    
    let collectionDetailButton = FlintButton(style: .able, title: "컬렉션 만들러 가기")
    
    let wrapperView = UIView()
    
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 47
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    let iconImageView = UIImageView().then {
        $0.image = .icPencilGradient
        $0.contentMode = .scaleAspectFit
    }
    
    let collectionTitleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.attributedText = .pretendard(.head1_sb_22, text: "지금 뜨는 추천을 모두 살펴봤어요")
    }
    let collectionDescriptionLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.attributedText = .pretendard(.body1_m_16, text: "마음에 남는 작품들로\n나만의 컬렉션을 만들어보세요!")
        $0.textAlignment = .center
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
        contentView.addSubviews(
            collectionDetailButton,
            wrapperView,
        )
        wrapperView.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(
            iconImageView,
            textStackView,
        )
        textStackView.addArrangedSubviews(
            collectionTitleLabel,
            collectionDescriptionLabel,
        )
    }
    
    override func setLayout() {
        collectionDetailButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        wrapperView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(collectionDetailButton.snp.top)
        }
        mainStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
