//
//  ExampleUseCase.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Combine

public protocol ExampleUseCase {
    func onTapExampleButton() -> AnyPublisher<ExampleEntity, AppError>
}

public final class ExampleUseCaseImpl: ExampleUseCase {
    private let repository: ExampleRepository
    
    init(repository: ExampleRepository) {
        self.repository = repository
    }
    
    public func onTapExampleButton() -> AnyPublisher<ExampleEntity, AppError> {
        return repository.fetchExample()
    }
}
