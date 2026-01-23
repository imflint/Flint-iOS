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

    public enum Row {
        case profileHeader(nickname: String, profileImageUrl: String, isFliner: Bool)

        case titleHeader(style: TitleHeaderStyle, title: String, subtitle: String)
        case preferenceChips(keywords: [KeywordEntity])

        case myCollections(items: [CollectionEntity])
        case savedCollections(items: [CollectionEntity])
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

    public init(
        userProfileUseCase: UserProfileUseCase,
        initialNickname: String = "플링",
        initialIsFliner: Bool = true
    ) {
        self.userProfileUseCase = userProfileUseCase
        self.nickname = initialNickname
        self.isFliner = initialIsFliner
        self.profileImageUrl = ""
        self.rows = makeRows()
    }

    // MARK: - Input
    public func load() {

        // 1️⃣ 프로필
        userProfileUseCase.fetchUserProfile(userId: 1)
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

        // 2️⃣ 키워드
        userProfileUseCase.fetchUserKeywords(userId: 1)
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

        // 3️⃣ 내 컬렉션
//        userProfileUseCase.fetchMyCollections()
        userProfileUseCase.fetchUserCollections(userId: 1)
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
    }

    // MARK: - Row builder
    private func makeRows() -> [Row] {
        var result: [Row] = []

        result.append(
            .profileHeader(
                nickname: nickname,
                profileImageUrl: profileImageUrl ?? "",
                isFliner: isFliner
            )
        )

        result.append(
            .titleHeader(
                style: .normal,
                title: "\(nickname)님의 취향 키워드",
                subtitle: "\(nickname)님이 관심 있어 하는 키워드에요"
            )
        )
        result.append(.preferenceChips(keywords: keywords))

        result.append(
            .titleHeader(
                style: .more,
                title: "\(nickname)님의 컬렉션",
                subtitle: "\(nickname)님이 생성한 컬렉션이에요"
            )
        )
        result.append(.myCollections(items: myCollections))

        result.append(
            .titleHeader(
                style: .more,
                title: "저장한 컬렉션",
                subtitle: "\(nickname)님이 저장한 컬렉션이에요"
            )
        )
        result.append(.savedCollections(items: savedCollections))

        return result
    }
}
