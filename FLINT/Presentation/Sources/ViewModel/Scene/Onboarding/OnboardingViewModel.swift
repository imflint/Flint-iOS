//
//  OnboardingViewModel.swift
//  Presentation
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import Domain

public protocol OnboardingViewModelInput {
    // nickname
    func checkNickname(_ nickname: String)
    
    // content select
    func fetchPopularContents()
    func searchContents(_ keyword: String)
    func clickContent(_ content: ContentEntity)
    func deleteContent(_ content: ContentEntity)
    
    // ott select
    func clickOtt(_ ott: Ott)
    
    // onboardingDone
    func signup()
}

public protocol OnboardingViewModelOutput {
    // term
    var agreedTerms: CurrentValueSubject<[SignUpTerm: Bool], Never> { get }
    
    // nickname
    var nickname: CurrentValueSubject<String, Never> { get }
    var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> { get }
    
    // content select
    var contentSelectQuestions: [String] { get set }
    var contents: CurrentValueSubject<[ContentEntity], Never> { get }
    var selectedContents: CurrentValueSubject<[ContentEntity], Never> { get }
    
    // ott select
    var selectedOtt: CurrentValueSubject<[Ott], Never> { get }
    var userId: CurrentValueSubject<String?, Never> { get }
}

public typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

public final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let checkNicknameUseCase: CheckNicknameUseCase
    private let fetchPopularContentsUseCase: FetchPopularContentsUseCase
    private let searchContentsUseCase: SearchContentsUseCase
    private let signupUseCase: SignupUseCase
    
    public let agreedTerms: CurrentValueSubject<[SignUpTerm: Bool], Never> = .init([
        .service: false,
        .privacy: false,
    ])
    
    public let nickname: CurrentValueSubject<String, Never> = .init("")
    public let nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> = .init(nil)
    
    public var contentSelectQuestions: [String] = [
        "이번 달, 가장 재미있었던 작품은 무엇인가요?",
        "여러번 정주행 했던 작품은 무엇인가요?",
        "좋아하는 인물이 등장하는 작품은 무엇인가요?",
        "요즘 밥 먹으면서 자주 보는 작품은 무엇인가요?",
        "\"이건 꼭 봐\"라고 말했던 작품은 무엇인가요?",
        "계절에 생각나는 작품은 무엇인가요?",
        "어렸을 적 즐겨봤던 추억의 작품은 무엇인가요?",
    ]
    public let contents: CurrentValueSubject<[ContentEntity], Never> = .init([])
    public let selectedContents: CurrentValueSubject<[ContentEntity], Never> = .init([])
    
    public let selectedOtt: CurrentValueSubject<[Ott], Never> = .init([])
    public let userId: CurrentValueSubject<String?, Never> = .init(nil)
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(
        checkNicknameUseCase: CheckNicknameUseCase,
        fetchPopularContentsUseCase: FetchPopularContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase,
        signupUseCase: SignupUseCase,
    ) {
        self.checkNicknameUseCase = checkNicknameUseCase
        self.fetchPopularContentsUseCase = fetchPopularContentsUseCase
        self.searchContentsUseCase = searchContentsUseCase
        self.signupUseCase = signupUseCase
    }
    
    public func checkNickname(_ nickname: String) {
        guard nickname.isValidNickname() else {
            nicknameValidState.send(.invalid)
            return
        }
        checkNicknameUseCase(nickname)
            .manageThread()
            .sinkHandledCompletion(receiveValue: { [weak self] isValidNickname in
                self?.nicknameValidState.send(isValidNickname ? .valid : .duplicate)
                if isValidNickname {
                    self?.nickname.send(nickname)
                }
            })
            .store(in: &cancellables)
    }
    
    public func fetchPopularContents() {
        fetchPopularContentsUseCase()
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.contents.send(contents)
            }
            .store(in: &cancellables)
    }
    
    public func searchContents(_ keyword: String) {
        searchContentsUseCase(keyword: keyword)
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.contents.send(contents)
            }
            .store(in: &cancellables)
    }
    
    public func clickContent(_ content: ContentEntity) {
        if let index = selectedContents.value.firstIndex(of: content) {
            selectedContents.value.remove(at: index)
        } else {
            selectedContents.value.insert(content, at: 0)
        }
    }
    
    public func deleteContent(_ content: ContentEntity) {
        selectedContents.value.removeAll(where: {
            content == $0
        })
    }
    
    public func clickOtt(_ ott: Ott) {
        if let index = selectedOtt.value.firstIndex(of: ott) {
            selectedOtt.value.remove(at: index)
        } else {
            selectedOtt.value.append(ott)
        }
    }
    
    public func signup() {
        signupUseCase(
            userInfo: SignupInfoEntity(
                nickname: nickname.value,
                favoriteContentIds: selectedContents.value.compactMap({ content in
                    Int(content.id)
                }),
                subscribedOttIds: selectedOtt.value.map(\.id)
            )
        )
        .manageThread()
        .sinkHandledCompletion { [weak self] userId in
            self?.userId.send(userId)
        }
        .store(in: &cancellables)
    }
}
