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
        case preferenceChips(keywords: [KeywordEntity])
        case titleHeader(style: TitleHeaderStyle, title: String, subtitle: String)
    }
    
    public enum TitleHeaderStyle {
        case normal
        case more
    }
    
    @Published public private(set) var rows: [Row] = []
    
    private let userProfileUseCase: UserProfileUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private var nickname: String
    private var isFliner: Bool
    private var profileImageUrl: String?
    private var keywords: [KeywordEntity] = []
    
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
    
    public func load() {
        // 1) 프로필 먼저
        userProfileUseCase.fetchUserProfile(userId: 1)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ fetchUserProfile failed:", error)
                }
            } receiveValue: { [weak self] profile in
                guard let self else { return }
                
                self.nickname = profile.nickname
                self.isFliner = profile.isFliner
                self.profileImageUrl = profile.profileImageUrl
                
                // 프로필만으로 1차 렌더
                self.rows = self.makeRows()
            }
            .store(in: &cancellables)
        
        // 2) 키워드 따로
        userProfileUseCase.fetchUserKeywords(userId: 2)
        //        userProfileUseCase.fetchMyKeywords()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ fetchUserKeywords failed:", error)
                }
            } receiveValue: { [weak self] keywords in
                guard let self else { return }
                
                self.keywords = keywords
                
                // 키워드까지 포함해서 갱신
                self.rows = self.makeRows()
            }
            .store(in: &cancellables)
    }
    
    private func makeRows() -> [Row] {
        [
            .profileHeader(
                nickname: nickname,
                profileImageUrl: profileImageUrl ?? "",
                isFliner: isFliner
            ),
            .titleHeader(style: .normal, title: "\(nickname)님의 취향키워드", subtitle: "\(nickname)님이 관심 있어 하는 키워드에요"),
            .preferenceChips(keywords: keywords),
            .titleHeader(style: .normal, title: "\(nickname)님의 컬렉션", subtitle: "\(nickname)님이 생성한 컬렉션이에요"),
            
                .titleHeader(style: .normal, title: "저장한 컬렉션", subtitle: "\(nickname)님이 저장한 컬렉션이에요"),
            .titleHeader(style: .normal, title: "저장한 작품", subtitle: "\(nickname)님이 저장한 작품이에요"),
        ]
    }
}
