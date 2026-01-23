//
//  HomeViewModel.swift
//  Presentation
//
//  Created by 소은 on 1/18/26.
//

import Combine
import Foundation

import Domain
import View

// MARK: - Section/Row Model

public struct HomeSectionModel {
    public let rows: [HomeRow]

    public init(rows: [HomeRow]) {
        self.rows = rows
    }
}

public enum HomeHeaderStyle {
    case normal
    case more
}

public enum HomeRow {
    case greeting(userName: String)
    case header(style: HomeHeaderStyle, title: String, subtitle: String)
    case fliner(items: [CollectionInfoEntity])
    case recentSaved(items: [RecentSavedContentItem])
    case ctaButton(title: String)
}

// MARK: - ViewModel Protocol

public protocol HomeViewModelInput {
    func fetchRecommendedCollections()
}

public protocol HomeViewModelOutput {
    var sections: CurrentValueSubject<[HomeSectionModel], Never> { get }
    var fetchSuccess: PassthroughSubject<Void, Never> { get }
    var fetchFailure: PassthroughSubject<Error, Never> { get }
}

public typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

// MARK: - DefaultHomeViewModel

public final class DefaultHomeViewModel: HomeViewModel {

    // MARK: - Dependency

    private let homeUseCase: HomeUseCase

    // MARK: - Output

    public var sections: CurrentValueSubject<[HomeSectionModel], Never>
    public var fetchSuccess: PassthroughSubject<Void, Never> = .init()
    public var fetchFailure: PassthroughSubject<Error, Never> = .init()

    // MARK: - State

    private let userName: String
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Init

    public init(
        userName: String,
        homeUseCase: HomeUseCase
    ) {
        self.userName = userName
        self.homeUseCase = homeUseCase

        let initial = Self.makeInitialSections(userName: userName)
        self.sections = .init(initial)
    }

    // MARK: - Input

    public func fetchRecommendedCollections() {
        homeUseCase.fetchRecommendedCollections()
            .manageThread()
            .map { Result<[CollectionInfoEntity], Error>.success($0) }
            .catch { Just(Result<[CollectionInfoEntity], Error>.failure($0)) }
            .sinkHandledCompletion { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let entities):
                    self.applyRecommendedCollections(entities)
                    self.fetchSuccess.send(())
                case .failure(let error):
                    self.fetchFailure.send(error)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Private

    private func applyRecommendedCollections(_ entities: [CollectionInfoEntity]) {
        var current = sections.value
        guard current.indices.contains(1) else {
            sections.send(current)
            return
        }

        // ✅ HomeSectionModel/HomeRow로 만들어야 타입이 맞음
        let newSection1 = HomeSectionModel(rows: [
            .header(
                style: .normal,
                title: "Fliner의 추천 컬렉션을 만나보세요",
                subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
            ),
            .fliner(items: entities)
        ])

        current[1] = newSection1
        sections.send(current)
    }

    private static func makeInitialSections(userName: String) -> [HomeSectionModel] {

        let dummyFlinerEntities: [CollectionInfoEntity] = [
            .init(imageUrlString: "", profileImageUrlString: "", title: "사랑에 빠지기 10초 전", userName: "사용자 이름"),
            .init(imageUrlString: "", profileImageUrlString: "", title: "한번 보면 못 빠져나오는…", userName: "사용자 이름"),
            .init(imageUrlString: "", profileImageUrlString: "", title: "주말에 보기 좋은 영화", userName: "사용자 이름")
        ]

        let dummyRecentSavedItems: [RecentSavedContentItem] = [
            .init(
                posterImageName: "img_background_gradiant_large",
                title: "듄: 파트 2",
                year: 2024,
                availableOn: [.netflix, .disneyPlus, .watcha],
                subscribedOn: [.netflix, .wave]
            ),
            .init(
                posterImageName: "img_background_gradiant_large",
                title: "오펜하이머",
                year: 2023,
                availableOn: [.wave, .tving, .netflix, .disneyPlus, .watcha],
                subscribedOn: [.tving, .wave, .netflix, .disneyPlus, .watcha]
            ),
            .init(
                posterImageName: "img_background_gradiant_large",
                title: "스즈메의 문단속",
                year: 2022,
                availableOn: [.netflix, .watcha, .disneyPlus],
                subscribedOn: [.netflix, .disneyPlus, .watcha]
            )
        ]

        let watchingCollectionEntities: [CollectionInfoEntity] = [
            .init(imageUrlString: "", profileImageUrlString: "", title: "요즘 빠진 스릴러만 모았어요", userName: "키키"),
            .init(imageUrlString: "", profileImageUrlString: "", title: "주말에 보기 좋은 힐링 영화", userName: "소은"),
            .init(imageUrlString: "", profileImageUrlString: "", title: "한 번 보면 끝까지 보는 시리즈", userName: "소은")
        ]

        let watchingSectionRows: [HomeRow] = watchingCollectionEntities.isEmpty
        ? [
            .header(style: .normal, title: "아직 읽어본 컬렉션이 없어요", subtitle: "천천히 둘러보며 끌리는 취향을 발견해보세요"),
            .ctaButton(title: "취향발견하러가기")
        ]
        : [
            .header(style: .more, title: "눈여겨보고 있는 컬렉션", subtitle: "\(userName)님이 최근 살펴본 컬렉션이에요"),
            .fliner(items: watchingCollectionEntities)
        ]

        return [
            .init(rows: [
                .greeting(userName: userName)
            ]),
            .init(rows: [
                .header(
                    style: .normal,
                    title: "Fliner의 추천 컬렉션을 만나보세요",
                    subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
                ),
                .fliner(items: dummyFlinerEntities)
            ]),
            .init(rows: [
                .header(
                    style: .normal,
                    title: "최근 저장한 콘텐츠",
                    subtitle: "현재 구독 중인 OTT에서 볼 수 있는 작품들이에요"
                ),
                .recentSaved(items: dummyRecentSavedItems)
            ]),
            .init(rows: watchingSectionRows)
        ]
    }
}
