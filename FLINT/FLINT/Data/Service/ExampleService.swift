//
//  ExampleService.swift
//  FLINT
//
//  Created by 진소은 on 1/9/26.
//

import Combine

protocol ExampleService {
    func fetchExample() -> AnyPublisher<ExampleDTO, NetworkError>
}

final class ExampleServiceImpl: BaseService<ExampleAPI>, ExampleService {
    func fetchExample() -> AnyPublisher<ExampleDTO, NetworkError> {
        request(.fetchExample, as: ExampleDTO.self)
    }
}
