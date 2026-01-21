//
//  HomeViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import Foundation
import UIKit
import Combine

import View
import Domain

// MARK: - Protocol

public protocol HomeViewModelInput {
    func fetchRecommendedCollections()
}

public protocol HomeViewModelOutput {
    var sections: CurrentValueSubject<[HomeViewModel.SectionModel], Never> { get }
}

public typealias HomeViewModelType = HomeViewModelInput & HomeViewModelOutput

// MARK: - Model

public final class HomeViewModel {

    public struct SectionModel {
        public let rows: [Row]

        public init(rows: [Row]) {
            self.rows = rows
        }
    }

    public enum Row {
        case greeting(userName: String)
        case header(style: TitleHeaderTableViewCell.HeaderStyle, title: String, subtitle: String)
        case fliner(items: [MoreNoMoreCollectionItem])
        case recentSaved(items: [RecentSavedContentItem])
        case ctaButton(title: String)
    }
}

// MARK: - Default

public final class DefaultHomeViewModel: HomeViewModelType {

    // MARK: - Dependency

    private let homeUseCase: HomeUseCase
    private let userName: String

    // MARK: - Output

    public let sections: CurrentValueSubject<[HomeViewModel.SectionModel], Never> = .init([])

    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(
        userName: String,
        homeUseCase: HomeUseCase
    ) {
        self.userName = userName
        self.homeUseCase = homeUseCase
        buildInitialSections()
    }

    // MARK: - Input

    public func fetchRecommendedCollections() {
        homeUseCase.fetchRecommendedCollections()
            .manageThread()
            .sinkHandledCompletion { [weak self] entity in
                self?.applyRecommended(entity)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private

private extension DefaultHomeViewModel {

    func buildInitialSections() {

        let recommendedSection = HomeViewModel.SectionModel(rows: [
            .header(
                style: .normal,
                title: "Fliner의 추천 컬렉션을 만나보세요",
                subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
            ),
            .fliner(items: [])
        ])

        // 기존 더미 유지 (최근 저장/최근 본 컬렉션 등)
        let dummyRecentSavedItems: [RecentSavedContentItem] = [
            .init(posterImageName: "img_background_gradiant_large",
                  title: "듄: 파트 2",
                  year: 2024,
                  availableOn: [.netflix, .disneyPlus, .watcha],
                  subscribedOn: [.netflix, .wave]),
            .init(posterImageName: "img_background_gradiant_large",
                  title: "오펜하이머",
                  year: 2023,
                  availableOn: [.wave, .tving, .netflix, .disneyPlus, .watcha],
                  subscribedOn: [.tving, .wave, .netflix, .disneyPlus, .watcha])
        ]

        let dummyWatchingItems: [MoreNoMoreCollectionItem] = [
            .init(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_middle"),
                profileImage: UIImage(named: "img_profile_blue"),
                title: "요즘 빠진 스릴러만 모았어요",
                userName: "키키"
            )
        ]

        let watchingSectionRows: [HomeViewModel.Row]
        if dummyWatchingItems.isEmpty {
            watchingSectionRows = [
                .header(
                    style: .normal,
                    title: "아직 읽어본 컬렉션이 없어요",
                    subtitle: "천천히 둘러보며 끌리는 취향을 발견해보세요"
                ),
                .ctaButton(title: "취향발견하러가기")
            ]
        } else {
            watchingSectionRows = [
                .header(
                    style: .more,
                    title: "눈여겨보고 있는 컬렉션",
                    subtitle: "\(userName)님이 최근 살펴본 컬렉션이에요"
                ),
                .fliner(items: dummyWatchingItems)
            ]
        }

        sections.send([
            .init(rows: [
                .greeting(userName: userName)
            ]),
            recommendedSection,
            .init(rows: [
                .header(
                    style: .normal,
                    title: "최근 저장한 콘텐츠",
                    subtitle: "현재 구독 중인 OTT에서 볼 수 있는 작품들이에요"
                ),
                .recentSaved(items: dummyRecentSavedItems)
            ]),
            .init(rows: watchingSectionRows)
        ])
    }

    func applyRecommended(_ entity: HomeRecommendedCollectionsEntity) {

        let items: [MoreNoMoreCollectionItem] = entity.collections.map { c in
            .init(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_middle"), // TODO: c.thumbnailUrl 로딩 연결
                profileImage: UIImage(named: "img_profile_blue"),        // TODO: c.profileUrl 로딩 연결
                title: c.title,
                userName: c.nickname
            )
        }

        var current = sections.value
        guard current.indices.contains(1) else { return }


        current[1] = HomeViewModel.SectionModel(rows: [
            .header(
                style: .normal,
                title: "Fliner의 추천 컬렉션을 만나보세요",
                subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
            ),
            .fliner(items: items)
        ])

        sections.send(current)
    }
}
