//
//  ExampleViewModel.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Combine

import Domain

public final class ExampleViewModel: BaseViewModelType {

    // MARK: - Input
    
    public struct Input {
        public let didTapFetch: AnyPublisher<Void, Never>
        
        public init(didTapFetch: AnyPublisher<Void, Never>) {
            self.didTapFetch = didTapFetch
        }
    }

    // MARK: - Output
    
    public struct Output {
        public let fetchResult: AnyPublisher<(title: String, team: String), Never>
        
        public init(fetchResult: AnyPublisher<(title: String, team: String), Never>) {
            self.fetchResult = fetchResult
        }
    }

    // MARK: - Properties
    
    private let useCase: ExampleUseCase
    private var cancellables = Set<AnyCancellable>()
    private let resultSubject = PassthroughSubject<(title: String, team: String), Never>()

    public init(useCase: ExampleUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        input.didTapFetch
            .sink { [weak self] in
                guard let self else { return }

                self.useCase.onTapExampleButton()
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] example in
                            self?.resultSubject.send((title: example.title, team: example.team))
                        }
                    )
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)

        return Output(fetchResult: resultSubject.eraseToAnyPublisher())
    }
}
