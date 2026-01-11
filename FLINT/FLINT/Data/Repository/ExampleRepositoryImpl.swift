//
//  ExampleRepositoryImpl.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.11.
//

import Combine

public final class ExampleRepositoryImpl: ExampleRepository {
    
    private let service: ExampleService

    init(service: ExampleService) {
        self.service = service
    }

    func fetchExample() -> AnyPublisher<ExampleEntity, AppError> {
        return service.fetchExample()
            .mapError { _ in AppError.network }
            .tryMap { dto -> ExampleEntity in
                try dto.toDomain()
            }
            .mapError { error in
                if let app = error as? AppError { return app }
                return .unknown
            }
            .eraseToAnyPublisher()
    }
}
