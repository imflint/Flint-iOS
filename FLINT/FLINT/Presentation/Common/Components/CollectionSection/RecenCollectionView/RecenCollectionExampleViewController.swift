//
//  RecenCollectionExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit

final class RecenCollectionExampleViewController: BaseViewController {
    
    private let stackView = UIStackView()
    
    private let recentSectionView = RecentCollectionSectionView()
    private let recommendSectionView = RecommendCollectionView()
    
    private let viewModel = RecentCollectionSectionViewModel(useCase: RecentCollectionUseCase())
    
    override func setUI() {
        view .backgroundColor = .flintBackground
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        recentSectionView.setHeader(title: "눈여겨보고 있는 컬렉션", subtitle: "키키님이 최근 살펴본 컬렉션이에요")
        
        
        recommendSectionView.setHeader(
            title: "Fliner의 추천 컬렉션",
            subtitle: "콘텐츠에 진심인 큐레이터들의 추천이에요"
        )
        
        recentSectionView.bind(viewModel: viewModel)
        recommendSectionView.bind(viewModel: viewModel)
        
        recentSectionView.onTapMore = { print("recent more tapped") }
        recommendSectionView.onTapMore = { print("recommend more tapped") }
        
        recentSectionView.onSelectItem = { id in print("recent selected:", id) }
        recommendSectionView.onSelectItem = { id in print("recommend selected:", id) }
        
        recentSectionView.start()
        recommendSectionView.start()
    }
    
    override func setHierarchy() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(recentSectionView)
        stackView.addArrangedSubview(recommendSectionView)
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
