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

    override func setUI() {
        view.backgroundColor = .flintBackground

        stackView.axis = .vertical
        stackView.spacing = 16

        recentSectionView.setHeader(
            title: "눈여겨보고 있는 컬렉션",
            subtitle: "키키님이 최근 살펴본 컬렉션이에요"
        )

        recommendSectionView.setHeader(
            title: "Fliner의 추천 컬렉션",
            subtitle: "콘텐츠에 진심인 큐레이터들의 추천이에요"
        )

        recentSectionView.onTapMore = { print("recent more tapped") }
        recommendSectionView.onTapMore = { print("recommend more tapped") }

        recentSectionView.onSelectItem = { id in print("recent selected:", id) }
        recommendSectionView.onSelectItem = { id in print("recommend selected:", id) }

        recentSectionView.update(items: makeRecentMockItems())
        recommendSectionView.update(items: makeRecommendMockItems())
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

// MARK: - Mock

private extension RecenCollectionExampleViewController {

    func makeRecentMockItems() -> [RecentCollectionItem] {
        [
            RecentCollectionItem(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_large"),
                title: "주말에 보기 좋은 영화 모음",
                userName: "키키",
                profileImage: UIImage(named: "img_profile_blue")
            ),
            RecentCollectionItem(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_large"),
                title: "정주행 추천 드라마",
                userName: "키키",
                profileImage: UIImage(named: "img_profile_blue")
            ),
            RecentCollectionItem(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_large"),
                title: "감성 애니 컬렉션",
                userName: "키키",
                profileImage: UIImage(named: "img_profile_blue")
            )
        ]
    }

    func makeRecommendMockItems() -> [RecentCollectionItem] {
        [
            RecentCollectionItem(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_large"),
                title: "이 주의 신작 TOP",
                userName: "Fliner",
                profileImage: UIImage(named: "img_profile_blue")
            ),
            RecentCollectionItem(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_large"),
                title: "숨겨진 명작 다큐",
                userName: "Fliner",
                profileImage: UIImage(named: "img_profile_blue")
            ),
            RecentCollectionItem(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_large"),
                title: "퇴근길에 가볍게",
                userName: "Fliner",
                profileImage: UIImage(named: "img_profile_blue")
            )
        ]
    }
}
