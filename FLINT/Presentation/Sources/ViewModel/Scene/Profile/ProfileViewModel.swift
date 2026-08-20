//
//  ProfileViewModel.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import Combine
import Foundation

import Domain

public final class ProfileViewModel {
    
    
    public let target: UserTarget
    
    public enum Row {
        case profileHeader(nickname: String, profileImageUrl: URL?, isFliner: Bool)
        case titleHeader(
            style: TitleHeaderStyle,
            title: String,
            subtitle: String,
            showInfo: Bool,
            showRefresh: Bool,
            isRefreshEnabled: Bool,
            isRefreshing: Bool,
            tooltipText: String?
        )
        case preferenceChips(keywords: [KeywordEntity])
        case keywordGraph(keywords: [KeywordEntity])
        case myCollections(items: [CollectionEntity])
        case savedCollections(items: [CollectionEntity])
        case savedContents(items: [ContentInfoEntity])
    }

    private enum Const {
        static let keywordInfoTooltipText =
        "저장한 작품들에서 반복되는 키워드를 분석해 취향키워드를 만들어요. 20개 이상 작품이 쌓이면 업데이트할 수 있어요."
    }
    
    public enum TitleHeaderStyle {
        case normal
        case more
    }

    // MARK: - Output
    @Published public private(set) var rows: [Row] = []

    public var isMe: Bool {
        if case .me = target { return true }
        return false
    }
    
    // MARK: - Dependencies
    private let fetchProfileUseCase: FetchProfileUseCase
    private let fetchKeywordsUseCase: FetchKeywordsUseCase
    private let fetchCreatedCollectionsUseCase: FetchCreatedCollectionsUseCase
    private let fetchBookmarkedCollectionsUseCase: FetchBookmarkedCollectionsUseCase
    private let fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase
    private let recalculateKeywordsUseCase: RecalculateKeywordsUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State
    private var nickname: String
    private var isFliner: Bool
    private var profileImageUrl: URL?

    private var keywords: [KeywordEntity] = []
    private var myCollections: [CollectionEntity] = []
    private var savedCollections: [CollectionEntity] = []
    private var savedContents: [ContentInfoEntity] = []
    private var isKeywordInfoTooltipVisible: Bool = false
    private var isRefreshing: Bool = false
    private var canRefresh: Bool = false

    public init(
        target: UserTarget,
        fetchProfileUseCase: FetchProfileUseCase,
        fetchKeywordsUseCase: FetchKeywordsUseCase,
        fetchCreatedCollectionsUseCase: FetchCreatedCollectionsUseCase,
        fetchBookmarkedCollectionsUseCase: FetchBookmarkedCollectionsUseCase,
        fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase,
        recalculateKeywordsUseCase: RecalculateKeywordsUseCase,
        initialNickname: String = "",
        initialIsFliner: Bool = false
    ) {
        self.target = target
        self.fetchProfileUseCase = fetchProfileUseCase
        self.fetchKeywordsUseCase = fetchKeywordsUseCase
        self.fetchCreatedCollectionsUseCase = fetchCreatedCollectionsUseCase
        self.fetchBookmarkedCollectionsUseCase = fetchBookmarkedCollectionsUseCase
        self.fetchBookmarkedContentsUseCase = fetchBookmarkedContentsUseCase
        self.recalculateKeywordsUseCase = recalculateKeywordsUseCase
        self.nickname = initialNickname
        self.isFliner = initialIsFliner
        self.rows = makeRows()
    }
    
    // MARK: - Input
    public func load() {
        // 중복 구독 방지: 이전 로드 subscription 정리
        cancellables.removeAll()

        fetchProfileUseCase(for: target)
            .manageThread()
            .sinkHandledCompletion(receiveValue: { [weak self] userProfileEntity in
                guard let self else { return }
                nickname = userProfileEntity.nickname
                isFliner = userProfileEntity.role == .fliner
                profileImageUrl = userProfileEntity.profileImageUrl
                canRefresh = userProfileEntity.keywordRecalculatable ?? false
                rows = makeRows()
            })
            .store(in: &cancellables)
        
        fetchKeywordsUseCase(for: target)
            .manageThread()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchKeywords failed:", error)
                }
            } receiveValue: { [weak self] keywords in
                guard let self else { return }
                self.keywords = keywords
                self.rows = self.makeRows()
            }
            .store(in: &cancellables)
        
        fetchCreatedCollectionsUseCase(for: target)
            .manageThread()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchMyCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                self.myCollections = items
                self.rows = self.makeRows()
            }
            .store(in: &cancellables)
        
        fetchBookmarkedCollectionsUseCase(for: target)
            .manageThread()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchSavedCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                print("asdf", items.count)
                guard let self else { return }
                self.savedCollections = items
                self.rows = self.makeRows()
            }
            .store(in: &cancellables)
        
        fetchBookmarkedContentsUseCase(for: target)
            .manageThread()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchSavedContents failed:", error)
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                self.savedContents = items
                self.rows = self.makeRows()
            }
            .store(in: &cancellables)
    }
    
    public func toggleKeywordInfoTooltip() {
        guard isMe else { return }
        isKeywordInfoTooltipVisible.toggle()
        rows = makeRows()
    }

    public func refreshKeywords() {
        guard isMe, !isRefreshing, canRefresh else { return }
        isRefreshing = true
        rows = makeRows()

        let target = self.target
        let fetchKeywords = fetchKeywordsUseCase

        recalculateKeywordsUseCase()
            .flatMap { _ in fetchKeywords(for: target) }
            .manageThread()
            .sink { [weak self] completion in
                guard let self else { return }
                self.isRefreshing = false
                if case let .failure(error) = completion {
                    print("recalculateKeywords failed:", error)
                    self.canRefresh = false
                }
                self.rows = self.makeRows()
            } receiveValue: { [weak self] keywords in
                guard let self else { return }
                self.keywords = keywords
                // 방금 재계산했으므로 이후 20개 새로 쌓일 때까지 재활성 불가
                self.canRefresh = false
                self.rows = self.makeRows()
            }
            .store(in: &cancellables)
    }

    // MARK: - Row builder
    private func makeRows() -> [Row] {
        var result: [Row] = []
        
        // 프로필 헤더는 항상 노출
        result.append(
            .profileHeader(
                nickname: nickname,
                profileImageUrl: profileImageUrl,
                isFliner: isFliner
            )
        )
        
        // items가 비어있으면 header와 content 둘 다 추가하지 않음
        func appendSectionIfNotEmpty(
            _ isEmpty: Bool,
            header: Row,
            content: Row
        ) {
            guard !isEmpty else { return }
            result.append(header)
            result.append(content)
        }
        
        // 취향 키워드 (header + chips + graph)
        if !keywords.isEmpty {
            result.append(
                .titleHeader(
                    style: .normal,
                    title: "\(nickname)님의 취향 키워드",
                    subtitle: "\(nickname)님이 관심 있어 하는 키워드에요",
                    showInfo: isMe,
                    showRefresh: isMe,
                    isRefreshEnabled: canRefresh,
                    isRefreshing: isRefreshing,
                    tooltipText: (isMe && isKeywordInfoTooltipVisible) ? Const.keywordInfoTooltipText : nil
                )
            )
            result.append(.preferenceChips(keywords: keywords))
            result.append(.keywordGraph(keywords: keywords))
        }

        // 내가 만든 컬렉션
        appendSectionIfNotEmpty(
            myCollections.isEmpty,
            header: .titleHeader(
                style: .more,
                title: "\(nickname)님의 컬렉션",
                subtitle: "\(nickname)님이 생성한 컬렉션이에요",
                showInfo: false,
                showRefresh: false,
                isRefreshEnabled: true,
                isRefreshing: false,
                tooltipText: nil
            ),
            content: .myCollections(items: myCollections)
        )

        // 저장한 컬렉션
        appendSectionIfNotEmpty(
            savedCollections.isEmpty,
            header: .titleHeader(
                style: .more,
                title: "저장한 컬렉션",
                subtitle: "\(nickname)님이 저장한 컬렉션이에요",
                showInfo: false,
                showRefresh: false,
                isRefreshEnabled: true,
                isRefreshing: false,
                tooltipText: nil
            ),
            content: .savedCollections(items: savedCollections)
        )

        // 저장한 작품
        appendSectionIfNotEmpty(
            savedContents.isEmpty,
            header: .titleHeader(
                style: .more,
                title: "저장한 작품",
                subtitle: "\(nickname)님이 저장한 작품이에요",
                showInfo: false,
                showRefresh: false,
                isRefreshEnabled: true,
                isRefreshing: false,
                tooltipText: nil
            ),
            content: .savedContents(items: savedContents)
        )
        
        return result
    }
}
