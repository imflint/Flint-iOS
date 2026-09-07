//
//  HomeViewModel.swift
//  Presentation
//
//  Created by 소은 on 2026.01.23.
//

import Combine
import Foundation

import Domain

public final class HomeViewModel {
    
    // MARK: - Output
    
    @Published public private(set) var sections: [SectionModel] = []
    
    // MARK: - Property
    
    private let fetchRecommendedCollectionsUseCase: FetchRecommendedCollectionsUseCase
    private let fetchPopularCollectionsUseCase: FetchPopularCollectionsUseCase
    private let fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    private let fetchRecentViewedCollectionsUseCase: FetchRecentViewedCollectionsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private var userName: String
    private var flinerCollections: [CollectionEntity] = []
    private var popularCollections: [CollectionEntity] = []
    private var recentSavedContents: [ContentInfoEntity] = []
    private var watchingCollections: [CollectionEntity] = []
    
    // MARK: - Model
    
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
        case flinerPager(items: [CollectionEntity])
        case fliner(items: [CollectionEntity])
        case recentSavedContents(items: [ContentInfoEntity])
        case ctaButton(title: String)
    }
    
    // MARK: - Init
    
    public init(
        fetchRecommendedCollectionsUseCase: FetchRecommendedCollectionsUseCase,
        fetchPopularCollectionsUseCase: FetchPopularCollectionsUseCase,
        fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase,
        fetchProfileUseCase: FetchProfileUseCase,
        fetchRecentViewedCollectionsUseCase: FetchRecentViewedCollectionsUseCase,
        initialUserName: String = "얀비"
    ) {
        self.fetchRecommendedCollectionsUseCase = fetchRecommendedCollectionsUseCase
        self.fetchPopularCollectionsUseCase = fetchPopularCollectionsUseCase
        self.fetchBookmarkedContentsUseCase = fetchBookmarkedContentsUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.fetchRecentViewedCollectionsUseCase = fetchRecentViewedCollectionsUseCase
        self.userName = initialUserName
        self.sections = makeSections()
    }
    
    // MARK: - Input
    
    public func load() {
        fetchProfileUseCase(for: .me)
            .manageThread()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchUserProfile failed:", error)
                }
            } receiveValue: { [weak self] profile in
                guard let self else { return }
                self.userName = profile.nickname
                self.sections = self.makeSections()
            }
            .store(in: &cancellables)
        
        fetchRecommendedCollectionsUseCase()
            .manageThread()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchRecommendedCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                self.flinerCollections = items
                self.sections = self.makeSections()
            }
            .store(in: &cancellables)
        
        fetchPopularCollectionsUseCase()
            .manageThread()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchPopularCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                self.popularCollections = items
                self.sections = self.makeSections()
            }
            .store(in: &cancellables)
        
        fetchBookmarkedContentsUseCase(for: .me)
            .manageThread()
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
        
        fetchRecentViewedCollectionsUseCase()
            .manageThread()
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
    
    // MARK: - Custom Method
    private func makeSections() -> [SectionModel] {
        var result: [SectionModel] = []

        result.append(
            .init(rows: [
                .greeting(userName: userName)
            ])
        )

        var flinerRows: [Row] = [
            .header(
                style: .normal,
                title: "Fliner의 추천 컬렉션",
                subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
            )
        ]

        if !flinerCollections.isEmpty {
            flinerRows.append(.flinerPager(items: flinerCollections))
        }

        result.append(.init(rows: flinerRows))

        var recentRows: [Row] = [
            .header(
                style: .normal,
                title: "최근 저장한 콘텐츠",
                subtitle: "관심이 가는 작품들을 다시 만나보세요"
            )
        ]

        if !recentSavedContents.isEmpty {
            recentRows.append(.recentSavedContents(items: recentSavedContents))
        }

        result.append(.init(rows: recentRows))

        let popularRows: [Row] = [
            .header(
                style: .more,
                title: "인기 컬렉션",
                subtitle: "사람들이 눈여겨보는 컬렉션들이에요"
            ),
            .fliner(items: popularCollections)
        ]

        result.append(.init(rows: popularRows))

        return result
    }
    
    public func reloadBookmarkedContents() {
        fetchBookmarkedContentsUseCase(for: .me)
            .manageThread()
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
    }
}


