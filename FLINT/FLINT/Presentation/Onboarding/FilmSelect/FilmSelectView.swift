//
//  FilmSelectView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit
import Then

class FilmSelectView: BaseView {
    
    // MARK: - Component
    
    let progressInfoView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    
    let progressView = UIProgressView().then {
        $0.progressTintColor = .flintSecondary400
        $0.trackTintColor = .flintGray600
    }
    let progressLabel = UILabel().then {
        $0.textColor = .flintWhite
    }
    
    let titleView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    
    let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 0
    }
    let subtitleLabel = UILabel().then {
        $0.textColor = .flintGray300
    }
    
    let searchView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    let searchTextField = SearchTextField(placeholder: "작품 이름")
    
    let filmPreviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 92, height: 92)
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0
        }
    ).then {
        $0.register(FilmPreviewCollectionViewCell.self)
        $0.backgroundColor = .flintBackground
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    let filmCollectionView: UICollectionView = {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(238)
            ),
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .flintBackground
        collectionView.register(OnboardingFilmCollectionViewCell.self)
        return collectionView
    }()
    
    let nextButton = FlintButton(style: .able, title: "다음")
    
    // MARK: - Basic
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setUI() {
        backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        addSubviews(
            progressInfoView,
            filmCollectionView,
            titleView,
            searchView,
            filmPreviewCollectionView,
            nextButton,
        )
        progressInfoView.addSubviews(progressView, progressLabel)
        titleView.addSubview(titleStackView)
        titleStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        searchView.addSubview(searchTextField)
    }
    
    override func setLayout() {
        progressInfoView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        progressView.snp.makeConstraints {
            $0.centerY.equalTo(progressLabel.snp.centerY)
            $0.leading.equalToSuperview().inset(18)
        }
        progressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.leading.equalTo(progressView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(11)
        }
        titleView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        searchView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(18)
        }
        filmPreviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(108)
        }
        filmCollectionView.snp.makeConstraints {
            $0.top.equalTo(progressInfoView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(filmCollectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
