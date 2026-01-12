//
//  ExampleViewModel.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Combine

final class ExampleViewModel: BaseViewModelType {

    // MARK: - Input
    
    struct Input {
        let didTapFetch: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    
    struct Output {
        let fetchResult: AnyPublisher<(title: String, team: String), Never>
    }

    // MARK: - Properties
    
    private let useCase: ExampleUseCase
    private var cancellables = Set<AnyCancellable>()
    private let resultSubject = PassthroughSubject<(title: String, team: String), Never>()

    init(useCase: ExampleUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform
    
    func transform(input: Input) -> Output {
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
