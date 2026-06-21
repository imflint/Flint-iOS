//
//  TermsAgreementView.swift
//  Presentation
//
//  Created by 김호성 on 2026.05.27.
//

import UIKit

import SnapKit
import Then

public class TermsAgreementView: BaseView {
    
    // MARK: - Component
    
    package let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.attributedText = .pretendard(.display2_m_28, text: "약관에 동의해주세요")
    }
    
    package let allAgreeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .center
        $0.distribution = .fill
    }
    package let allAgreeCheckbox = FlintCheckbox()
    package let allAgreeLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.attributedText = .pretendard(.body1_r_16, text: "전체 동의")
    }
    
    package let separatorView = UIView().then {
        $0.backgroundColor = .flintGray600
    }
    
    package let nextButton = FlintButton(style: .able, title: "동의하기").then {
        $0.isEnabled = false
    }
    
    package let termAgreementsCollectionView: UICollectionView = {
        var collectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        collectionLayoutListConfiguration.backgroundColor = .flintBackground
        collectionLayoutListConfiguration.showsSeparators = false
        let collectionViewLayout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = NSCollectionLayoutSection.list(using: collectionLayoutListConfiguration, layoutEnvironment: layoutEnvironment)
            section.contentInsets = .init(top: 16, leading: 16, bottom: 12, trailing: 16)
            section.interGroupSpacing = 8
            return section
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    // MARK: - Basic
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        backgroundColor = .flintBackground
    }
    
    public override func setHierarchy() {
        addSubviews(
            titleLabel,
            allAgreeStackView,
            separatorView,
            termAgreementsCollectionView,
            nextButton
        )
        allAgreeStackView.addArrangedSubviews(
            allAgreeCheckbox,
            allAgreeLabel,
        )
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        allAgreeStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        allAgreeCheckbox.snp.makeConstraints {
            $0.size.equalTo(48)
        }
        separatorView.snp.makeConstraints {
            $0.top.equalTo(allAgreeStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        termAgreementsCollectionView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(termAgreementsCollectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
