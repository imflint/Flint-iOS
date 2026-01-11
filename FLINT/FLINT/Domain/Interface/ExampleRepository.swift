//
//  ExampleRepository.swift
//  FLINT
//
//  Created by 진소은 on 1/9/26.
//

import Combine

protocol ExampleRepository {
    func fetchExample() -> AnyPublisher<ExampleEntity, AppError>
}
