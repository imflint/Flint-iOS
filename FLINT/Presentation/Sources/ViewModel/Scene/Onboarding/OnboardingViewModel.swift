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
    var isValidNickname: CurrentValueSubject<Bool?, Never> { get }
}

public typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

public final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let nicknameUseCase: NicknameUseCase
    
    public var isValidNickname: CurrentValueSubject<Bool?, Never> = .init(nil)
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(nicknameUseCase: NicknameUseCase) {
        self.nicknameUseCase = nicknameUseCase
    }
    
    public func checkNickname(_ nickname: String) {
        nicknameUseCase.checkNickname(nickname)
            .manageThread()
            .map(\.available)
            .sinkHandledCompletion(receiveValue: { [weak self] isValidNickname in
                self?.isValidNickname.send(isValidNickname)
            })
            .store(in: &cancellables)
    }
}
