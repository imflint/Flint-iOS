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
    var nickname: CurrentValueSubject<String, Never> { get }
    var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> { get }
}

public typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

public final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let nicknameUseCase: NicknameUseCase
    
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
