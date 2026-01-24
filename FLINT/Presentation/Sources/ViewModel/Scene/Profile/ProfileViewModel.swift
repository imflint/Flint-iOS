//
//  ProfileViewModel.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import Foundation
import Combine

import Domain
import Entity

public final class ProfileViewModel {
    
    public enum Target: Equatable {
        case me
        case user(userId: Int)
    }
    
    private let target: Target
    
    public enum Row {
        case profileHeader(nickname: String, profileImageUrl: String, isFliner: Bool)
        case titleHeader(style: TitleHeaderStyle, title: String, subtitle: String)
        case preferenceChips(keywords: [KeywordEntity])
        case myCollections(items: [CollectionEntity])
        case savedCollections(items: [CollectionEntity])
        case savedContents(items: [ContentInfoEntity])
    }
    
    public enum TitleHeaderStyle {
        case normal
        case more
    }
    
    // MARK: - Output
    @Published public private(set) var rows: [Row] = []
    
    // MARK: - Dependencies
    private let userProfileUseCase: UserProfileUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State
    private var nickname: String
    private var isFliner: Bool
    private var profileImageUrl: String?
    
    private var keywords: [KeywordEntity] = []
    private var myCollections: [CollectionEntity] = []
    private var savedCollections: [CollectionEntity] = []
    private var savedContents: [ContentInfoEntity] = []
    
    public init(
        target: Target = .me,
        userProfileUseCase: UserProfileUseCase,
        initialNickname: String = "플링",
        initialIsFliner: Bool = true
    ) {
        self.target = target
        self.userProfileUseCase = userProfileUseCase
        self.nickname = initialNickname
        self.isFliner = initialIsFliner
        self.profileImageUrl = ""
        self.rows = makeRows()
    }
    
    // MARK: - Input
    public func load() {
        
        switch target {
        case .me:
            userProfileUseCase.fetchMyProfile()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchProfile failed:", error)
                    }
                } receiveValue: { [weak self] profile in
                    guard let self else { return }
                    self.nickname = profile.nickname
                    self.isFliner = profile.isFliner
                    self.profileImageUrl = profile.profileImageUrl
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            userProfileUseCase.fetchMyKeywords()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchKeywords failed:", error)
                    }
                } receiveValue: { [weak self] keywords in
                    guard let self else { return }
                    self.keywords = keywords
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            
            userProfileUseCase.fetchMyCollections()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchMyCollections failed:", error)
                    }
                } receiveValue: { [weak self] items in
                    guard let self else { return }
                    self.myCollections = items
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            
            userProfileUseCase.fetchMyBookmarkedCollections()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchSavedCollections failed:", error)
                    }
                } receiveValue: { [weak self] items in
                    print("asdf", items.count)
                    guard let self else { return }
                    self.savedCollections = items
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            
            userProfileUseCase.fetchMyBookmarkedContents()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchSavedContents failed:", error)
                    }
                } receiveValue: { [weak self] items in
                    guard let self else { return }
                    self.savedContents = items
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            
            
            
        case .user(let userId):
            userProfileUseCase.fetchUserProfile(userId: Int64(userId))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchProfile failed:", error)
                    }
                } receiveValue: { [weak self] profile in
                    guard let self else { return }
                    self.nickname = profile.nickname
                    self.isFliner = profile.isFliner
                    self.profileImageUrl = profile.profileImageUrl
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            userProfileUseCase.fetchUserKeywords(userId: Int64(userId))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchKeywords failed:", error)
                    }
                } receiveValue: { [weak self] keywords in
                    guard let self else { return }
                    self.keywords = keywords
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            
            userProfileUseCase.fetchUserCollections(userId: Int64(userId))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchMyCollections failed:", error)
                    }
                } receiveValue: { [weak self] items in
                    guard let self else { return }
                    self.myCollections = items
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            
            userProfileUseCase.fetchBookmarkedCollections(userId: Int64(userId))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchSavedCollections failed:", error)
                    }
                } receiveValue: { [weak self] items in
                    print("asdf", items.count)
                    guard let self else { return }
                    self.savedCollections = items
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
            
            userProfileUseCase.fetchBookmarkedContents(userId: Int64(userId))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("❌ fetchSavedContents failed:", error)
                    }
                } receiveValue: { [weak self] items in
                    guard let self else { return }
                    self.savedContents = items
                    self.rows = self.makeRows()
                }
                .store(in: &cancellables)
        }
    }
    
    //
    
    // MARK: - Row builder
    private func makeRows() -> [Row] {
        var result: [Row] = []
        
        // 프로필 헤더는 항상 노출
        result.append(
            .profileHeader(
                nickname: nickname,
                profileImageUrl: profileImageUrl ?? "",
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
        
        // 취향 키워드
        appendSectionIfNotEmpty(
            keywords.isEmpty,
            header: .titleHeader(
                style: .normal,
                title: "\(nickname)님의 취향 키워드",
                subtitle: "\(nickname)님이 관심 있어 하는 키워드에요"
            ),
            content: .preferenceChips(keywords: keywords)
        )
        
        // 내가 만든 컬렉션
        appendSectionIfNotEmpty(
            myCollections.isEmpty,
            header: .titleHeader(
                style: .normal,
                title: "\(nickname)님의 컬렉션",
                subtitle: "\(nickname)님이 생성한 컬렉션이에요"
            ),
            content: .myCollections(items: myCollections)
        )
        
        // 저장한 컬렉션
        appendSectionIfNotEmpty(
            savedCollections.isEmpty,
            header: .titleHeader(
                style: .normal,
                title: "저장한 컬렉션",
                subtitle: "\(nickname)님이 저장한 컬렉션이에요"
            ),
            content: .savedCollections(items: savedCollections)
        )
        
        // 저장한 콘텐츠
        appendSectionIfNotEmpty(
            savedContents.isEmpty,
            header: .titleHeader(
                style: .normal,
                title: "저장한 콘텐츠",
                subtitle: "\(nickname)님이 저장한 콘텐츠에요"
            ),
            content: .savedContents(items: savedContents)
        )
        
        return result
    }
}
