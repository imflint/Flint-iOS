//
//  ExampleRepository.swift
//  FLINT
//
//  Created by 진소은 on 1/9/26.
//

import Combine

import Entity

public protocol ExampleRepository {
    func fetchExample() -> AnyPublisher<ExampleEntity, AppError>
}
