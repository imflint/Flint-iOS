//
//  HomeViewModel.swift
//  Presentation
//
//  Created by 소은 on 2026.01.23.
//

//
//  HomeViewModel.swift
//  Presentation
//
//  Created by 소은 on 2026.01.23.
//

import Foundation
import Combine

import Domain
import Entity

public final class HomeViewModel {

    
    // MARK: - Section / Row

    public struct SectionModel {
        public let rows: [Row]
    }

    public enum TitleHeaderStyle {
        case normal
        case more
    }

    public enum Row {
        case greeting(userName: String)
        case header(style: TitleHeaderStyle, title: String, subtitle: String)
        case fliner(items: [CollectionEntity])
        case recentSavedContents(items: [ContentInfoEntity])
        case ctaButton(title: String)
    }

    // MARK: - Output

    @Published public private(set) var sections: [SectionModel] = []
    private var watchingCollections: [CollectionEntity] = []

    // MARK: - Dependencies

    private let homeUseCase: HomeUseCase
    private let userProfileUseCase: UserProfileUseCase
    private let fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State

    private var userName: String
    private var flinerCollections: [CollectionEntity] = []
    private var recentSavedContents: [ContentInfoEntity] = []

    // MARK: - Init

    public init(
        homeUseCase: HomeUseCase,
        userProfileUseCase: UserProfileUseCase,
        fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase,
        initialUserName: String = "얀비"
    ) {
        self.homeUseCase = homeUseCase
        self.userProfileUseCase = userProfileUseCase
        self.fetchWatchingCollectionsUseCase = fetchWatchingCollectionsUseCase
        self.userName = initialUserName
        self.sections = makeSections()
    }

    // MARK: - Input

    public func load() {
        
        userProfileUseCase.fetchUserProfile(userId: 1)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(" fetchUserProfile failed:", error)
                }
            } receiveValue: { [weak self] profile in
                guard let self else { return }
                self.userName = profile.nickname
                self.sections = self.makeSections()
            }
            .store(in: &cancellables)

        // 1) Fliner 추천
        homeUseCase.fetchRecommendedCollections()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchRecommendedCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }

                self.flinerCollections = items.map { info in
                    CollectionEntity(
                        id: "",
                        thumbnailUrl: info.imageUrlString,
                        title: info.title,
                        description: "",
                        imageList: [],
                        bookmarkCount: 0,
                        isBookmarked: false,
                        userId: "",
                        nickname: info.userName,
                        profileImageUrl: info.profileImageUrlString
                    )
                    
                }

                self.sections = self.makeSections()
            }
            .store(in: &cancellables)

        // 2) 최근 저장한 콘텐츠
        userProfileUseCase.fetchMyBookmarkedContents()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchMyBookmarkedContents failed:", error)
                }
            } receiveValue: { [weak self] contents in
                guard let self else { return }
                self.recentSavedContents = contents
                self.sections = self.makeSections()
            }
            .store(in: &cancellables)
        
        fetchWatchingCollectionsUseCase.fetchWatchingCollections()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchWatchingCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                self.watchingCollections = items
                self.sections = self.makeSections()
            }
            .store(in: &cancellables)
        
        
    }

    // MARK: - Builder

    private func makeSections() -> [SectionModel] {
        var result: [SectionModel] = []

        // 1) Greeting
        result.append(
            .init(rows: [
                .greeting(userName: userName)
            ])
        )

        // 2) Fliner 추천 컬렉션
        var flinerRows: [Row] = [
            .header(
                style: .normal,
                title: "Fliner의 추천 컬렉션을 만나보세요",
                subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
            )
        ]

        if !flinerCollections.isEmpty {
            flinerRows.append(.fliner(items: flinerCollections))
        }

        result.append(.init(rows: flinerRows))

        // 3) 최근 저장한 콘텐츠
        var recentRows: [Row] = [
            .header(
                style: .normal,
                title: "최근 저장한 콘텐츠",
                subtitle: "현재 구독 중인 OTT에서 볼 수 있는 작품들이에요"
            )
        ]

        if !recentSavedContents.isEmpty {
            recentRows.append(.recentSavedContents(items: recentSavedContents))
        }

        result.append(.init(rows: recentRows))

        let watchingRows: [Row]

                if watchingCollections.isEmpty {
                    watchingRows = [
                        .header(
                            style: .normal,
                            title: "아직 읽어본 컬렉션이 없어요",
                            subtitle: "천천히 둘러보며 끌리는 취향을 발견해보세요"
                        ),
                        .ctaButton(title: "취향 발견하러 가기")
                    ]
                } else {
                    watchingRows = [
                        .header(
                            style: .more,
                            title: "눈여겨보고 있는 컬렉션",
                            subtitle: "\(userName)님이 최근 살펴본 컬렉션이에요"
                        ),
                        .fliner(items: watchingCollections)
                    ]
                }

                result.append(.init(rows: watchingRows))

        return result
    }
}

