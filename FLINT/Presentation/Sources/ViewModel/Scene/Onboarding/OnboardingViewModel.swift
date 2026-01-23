//
//  File.swift
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
    
    // film select
    func fetchContents()
    func searchContents(_ keyword: String)
    func clickContent(_ content: ContentEntity)
    func deleteContent(_ content: ContentEntity) 
    
    // ott select
    func clickOtt(_ ott: Ott)
    
    // onboardingDone
    func signup()
}

public protocol OnboardingViewModelOutput {
    // nickname
    var nickname: CurrentValueSubject<String, Never> { get }
    var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> { get }
    
    // film select
    var filmSelectQuestions: [String] { get set }
    var contents: CurrentValueSubject<[ContentEntity], Never> { get set }
    var selectedContents: CurrentValueSubject<[ContentEntity], Never> { get set }
    
    // ott select
    var selectedOtt: CurrentValueSubject<[Ott], Never> { get set }
}

public typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

public final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let nicknameUseCase: NicknameUseCase
    private let contentsUseCase: ContentsUseCase
    private let searchContentsUseCase: SearchContentsUseCase
    private let signupUseCase: SignupUseCase
    
    public var nickname: CurrentValueSubject<String, Never> = .init("")
    public var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> = .init(nil)
    
    public var filmSelectQuestions: [String] = [
        "이번 달, 가장 재미있었던 작품은 무엇인가요?",
        "여러번 정주행 했던 작품은 무엇인가요?",
        "좋아하는 인물이 등장하는 작품은 무엇인가요?",
        "요즘 밥 먹으면서 자주 보는 작품은 무엇인가요?",
        "\"이건 꼭 봐\"라고 말했던 작품은 무엇인가요?",
        "계절에 생각나는 작품은 무엇인가요?",
        "어렸을 적 즐겨봤던 추억의 작품은 무엇인가요?",
    ]
    public var contents: CurrentValueSubject<[ContentEntity], Never> = .init([])
    public var selectedContents: CurrentValueSubject<[ContentEntity], Never> = .init([])
    
    public var selectedOtt: CurrentValueSubject<[Ott], Never> = .init([])
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(
        nicknameUseCase: NicknameUseCase,
        contentsUseCase: ContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase,
        signupUseCase: SignupUseCase
    ) {
        self.nicknameUseCase = nicknameUseCase
        self.contentsUseCase = contentsUseCase
        self.searchContentsUseCase = searchContentsUseCase
        self.signupUseCase = signupUseCase
    }
    
    public func checkNickname(_ nickname: String) {
        guard nickname.isValidNickname() else {
            nicknameValidState.send(.invalid)
            return
        }
        nicknameUseCase.checkNickname(nickname)
            .manageThread()
            .sinkHandledCompletion(receiveValue: { [weak self] isValidNickname in
                self?.nicknameValidState.send(isValidNickname ? .valid : .duplicate)
                if isValidNickname {
                    self?.nickname.send(nickname)
                }
            })
            .store(in: &cancellables)
    }
    
    public func fetchContents() {
        contentsUseCase.fetchContents()
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.contents.send(contents)
            }
            .store(in: &cancellables)
    }
    
    public func searchContents(_ keyword: String) {
        searchContentsUseCase.searchContents(keyword)
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
        signupUseCase.signup(
            SignupInfoEntity(
                tempToken: "비밀이얌 ㅎㅎ;;",
                nickname: nickname.value,
                favoriteContentIds: selectedContents.value.compactMap({ content in
                    Int(content.id)
                }),
                subscribedOttIds: selectedOtt.value.map(\.id)
            )
        )
        .manageThread()
        .sinkHandledCompletion { userId in
            Log.d(userId)
        }
        .store(in: &cancellables)
    }
}
