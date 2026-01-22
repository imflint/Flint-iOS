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
    func checkNickname(_ nickname: String)
}

public protocol OnboardingViewModelOutput {
    var filmSelectQuestions: [String] { get set }
    var nickname: CurrentValueSubject<String, Never> { get }
    var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> { get }
}

public typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

public final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let nicknameUseCase: NicknameUseCase
    
    public var filmSelectQuestions: [String] = [
        "이번 달, 가장 재미있었던 작품은 무엇인가요?",
        "여러번 정주행 했던 작품은 무엇인가요?",
        "좋아하는 인물이 등장하는 작품은 무엇인가요?",
        "요즘 밥 먹으면서 자주 보는 작품은 무엇인가요?",
        "\"이건 꼭 봐\"라고 말했던 작품은 무엇인가요?",
        "계절에 생각나는 작품은 무엇인가요?",
        "어렸을 적 즐겨봤던 추억의 작품은 무엇인가요?",
    ]
    public var nickname: CurrentValueSubject<String, Never> = .init("")
    public var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> = .init(nil)
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(nicknameUseCase: NicknameUseCase) {
        self.nicknameUseCase = nicknameUseCase
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
}
