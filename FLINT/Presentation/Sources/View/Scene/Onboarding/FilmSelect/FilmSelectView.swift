//
//  FilmSelectView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit
import Then

public final class FilmSelectView: BaseView {
    
    // MARK: - Component
    
    public let progressInfoView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    
    public let progressView = UIProgressView().then {
        $0.progressTintColor = .flintSecondary400
        $0.trackTintColor = .flintGray600
    }
    public let progressLabel = UILabel().then {
        $0.textColor = .flintWhite
    }
    
    public let foldableViewBackgroundView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    public let foldableView = UIView()
    
    public let titleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 0
    }
    public let subtitleLabelView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    public let subtitleLabel = UILabel().then {
        $0.textColor = .flintGray300
    }
    
    public let searchView = UIView().then {
        $0.backgroundColor = .flintBackground
        $0.layer.applyShadow(alpha: 0.25, blur: 12, y: 12)
    }
    public let searchTextField = SearchTextField(placeholder: "작품 이름").then {
        $0.returnKeyType = .search
    }
    public let collectionViewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
    }
    public let filmPreviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 92, height: 92)
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0
        }
    ).then {
        $0.isHidden = true
        $0.layer.applyShadow(alpha: 0.25, blur: 12, y: 12)
        $0.register(FilmPreviewCollectionViewCell.self)
        $0.backgroundColor = .flintBackground
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    public let filmCollectionView: UICollectionView = {
        let uselessHeight: CGFloat = 230
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .estimated(uselessHeight)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(uselessHeight)
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
        section.contentInsets = .zero
        collectionView.backgroundColor = .flintBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(OnboardingFilmCollectionViewCell.self)
        return collectionView
    }()
    
    public let nextButton = FlintButton(style: .able, title: "다음")
    
    public let emptyView = UIView().then {
        $0.isHidden = true
    }
    public let emptyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    public let emptyImageView = UIImageView().then {
        $0.image = .icNoneGradient
        $0.contentMode = .scaleAspectFit
    }
    public let emptyTitleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.attributedText = .pretendard(.head3_m_18, text: "아직 준비 중인 작품이에요")
    }
    
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
            collectionViewStackView,
            foldableViewBackgroundView,
            foldableView,
            subtitleLabelView,
            progressInfoView,
            searchView,
            nextButton,
            emptyView
        )
        collectionViewStackView.addArrangedSubviews(
            filmPreviewCollectionView,
            filmCollectionView,
        )
        progressInfoView.addSubviews(progressView, progressLabel)
        foldableView.addSubview(titleLabel)
        subtitleLabelView.addSubview(subtitleLabel)
        searchView.addSubview(searchTextField)
        emptyView.addSubviews(emptyStackView)
        emptyStackView.addArrangedSubviews(
            emptyImageView,
            emptyTitleLabel,
        )
    }
    
    public override func setLayout() {
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
        foldableView.snp.makeConstraints {
            $0.top.equalTo(progressInfoView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        subtitleLabelView.snp.makeConstraints {
            $0.top.equalTo(foldableView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        foldableViewBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(foldableView)
        }
        searchView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabelView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(18)
        }
        collectionViewStackView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        filmPreviewCollectionView.snp.makeConstraints {
            $0.height.equalTo(108)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(collectionViewStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(filmCollectionView)
        }
        emptyStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Global Function
    
    public func updateFoldableViewYOffset(_ y: CGFloat) {
        foldableView.snp.updateConstraints {
            $0.top.equalTo(progressInfoView.snp.bottom).offset(y)
        }
    }
}
