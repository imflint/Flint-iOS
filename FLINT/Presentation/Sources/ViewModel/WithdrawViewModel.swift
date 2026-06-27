//
//  WithdrawViewModel.swift
//  Presentation
//
//  Created by 소은 on 5/13/26.
//

import Foundation
import Combine

import Domain

public final class WithdrawViewModel {

    // MARK: - Property

    private let withDrawUseCase: WithDrawUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(withDrawUseCase: WithDrawUseCase) {
        self.withDrawUseCase = withDrawUseCase
    }
    
    // MARK: - Input
    
    public struct Input {
        public let agreementCheckTapped: AnyPublisher<Bool, Never>
        public let withdrawButtonTapped: AnyPublisher<Void, Never>
        
        public init(
            agreementCheckTapped: AnyPublisher<Bool, Never>,
            withdrawButtonTapped: AnyPublisher<Void, Never>
        ) {
            self.agreementCheckTapped = agreementCheckTapped
            self.withdrawButtonTapped = withdrawButtonTapped
        }
    }
    
    // MARK: - Output
    
    public struct Output {
        public let isWithdrawEnabled: AnyPublisher<Bool, Never>
        public let withdrawSuccess: AnyPublisher<Void, Never>
        public let withdrawError: AnyPublisher<Error, Never>
    }
    
    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        let isWithdrawEnabledPublisher = input.agreementCheckTapped
            .eraseToAnyPublisher()
        
        let withdrawResult = input.withdrawButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.withdraw()
            }
            .share()
        
        let withdrawSuccess = withdrawResult
            .compactMap { result -> Void? in
                if case .success = result {
                    return ()
                }
                return nil
            }
            .eraseToAnyPublisher()
        
        let withdrawError = withdrawResult
            .compactMap { result -> Error? in
                if case .failure(let error) = result {
                    return error
                }
                return nil
            }
            .eraseToAnyPublisher()
        
        return Output(
            isWithdrawEnabled: isWithdrawEnabledPublisher,
            withdrawSuccess: withdrawSuccess,
            withdrawError: withdrawError
        )
    }
    
    // MARK: - Custom Method
    
    private func withdraw() -> AnyPublisher<Result<Void, Error>, Never> {
        return withDrawUseCase(agreedTermsIds: ["10"])
            .map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}
