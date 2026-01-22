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
        case profileHeader(nickname: String, isFliner: Bool)
    }

    // MARK: - Output

    @Published public private(set) var rows: [Row] = []

    // MARK: - Dependencies

    private let userProfileUseCase: UserProfileUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State

    private var nickname: String
    private var isFliner: Bool

    public init(
        userProfileUseCase: UserProfileUseCase,
        initialNickname: String = "쏘나기",
        initialIsFliner: Bool = true
    ) {
        self.userProfileUseCase = userProfileUseCase
        self.nickname = initialNickname
        self.isFliner = initialIsFliner
        self.rows = makeRows(nickname: initialNickname, isFliner: initialIsFliner)
    }

    // MARK: - Input

    public func load() {
        userProfileUseCase.fetchMyProfile()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] profile in
                guard let self else { return }
                self.nickname = profile.nickname
                self.isFliner = profile.isFliner
                self.rows = self.makeRows(nickname: profile.nickname, isFliner: profile.isFliner)
            }
            .store(in: &cancellables)
    }

    // MARK: - Row builder

    private func makeRows(nickname: String, isFliner: Bool) -> [Row] {
        [
            .profileHeader(nickname: nickname, isFliner: isFliner)
        ]
    }
}

//
//public final class ProfileViewModel {
//
//    public enum Row {
//        case profileHeader(nickname: String, isFliner: Bool)
//        case titleHeader(style: TitleHeaderStyle, title: String, subtitle: String)
//        case preferenceChips(keywords: [KeywordDTO])
//        case collection(items: [MoreNoMoreCollectionItem])
//        case recentSaved(items: [RecentSavedContentItem])
//    }
//
//    public enum TitleHeaderStyle {
//        case normal
//        case more
//    }
//
//    // MARK: - Output
//
//    @Published public private(set) var rows: [Row] = []
//
//    // MARK: - Dependencies
//
//    private let userProfileUseCase: UserProfileUseCase
//
//    // MARK: - Dummy / Local Data (기존 VC 더미들 그대로 옮김)
//
//    private let keywords: [KeywordDTO]
//    private let myCollections: [MoreNoMoreCollectionItem]
//    private let savedCollections: [MoreNoMoreCollectionItem]
//    private let recentSaved: [RecentSavedContentItem]
//
//    private var cancellables = Set<AnyCancellable>()
//
//    // MARK: - State
//
//    private var nickname: String
//    private var isFliner: Bool
//
//    public init(
//        userProfileUseCase: UserProfileUseCase,
//        keywords: [KeywordDTO] = [],
//        myCollections: [MoreNoMoreCollectionItem] = [],
//        savedCollections: [MoreNoMoreCollectionItem] = [],
//        recentSaved: [RecentSavedContentItem] = [],
//        initialNickname: String = "쏘나기",
//        initialIsFliner: Bool = true
//    ) {
//        self.userProfileUseCase = userProfileUseCase
//        self.keywords = keywords
//        self.myCollections = myCollections
//        self.savedCollections = savedCollections
//        self.recentSaved = recentSaved
//        self.nickname = initialNickname
//        self.isFliner = initialIsFliner
//
//        self.rows = makeRows(nickname: initialNickname, isFliner: initialIsFliner)
//    }
//
//    // MARK: - Input
//
//    public func load() {
//        userProfileUseCase.fetchMyProfile()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//            } receiveValue: { [weak self] profile in
//                guard let self else { return }
//                self.nickname = profile.nickname
//                self.isFliner = profile.isFliner
//                self.rows = self.makeRows(nickname: profile.nickname, isFliner: profile.isFliner)
//            }
//            .store(in: &cancellables)
//    }
//
//    // MARK: - Row builder
//
//    private func makeRows(nickname: String, isFliner: Bool) -> [Row] {
//        return [
//            .profileHeader(nickname: nickname, isFliner: isFliner),
//
//            .titleHeader(
//                style: .normal,
//                title: "\(nickname)님의 취향 키워드",
//                subtitle: "\(nickname)님이 관심있어하는 키워드예요"
//            ),
//            .preferenceChips(keywords: keywords),
//
//            .titleHeader(
//                style: .more,
//                title: "\(nickname)님의 컬렉션",
//                subtitle: "\(nickname)님이 생성한 컬렉션이에요"
//            ),
//            .collection(items: myCollections),
//
//            .titleHeader(
//                style: .more,
//                title: "저장한 컬렉션",
//                subtitle: "\(nickname)님이 저장한 컬렉션이에요"
//            ),
//            .collection(items: savedCollections),
//
//            .titleHeader(
//                style: .more,
//                title: "저장한 작품",
//                subtitle: "\(nickname)님이 저장한 작품이에요"
//            ),
//            .recentSaved(items: recentSaved)
//        ]
//    }
//}
