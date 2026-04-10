//
//  CreateCollectionUseCaseFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Domain

protocol CreateCollectionUseCaseFactory: CollectionRepositoryFactory {
    func makeCreateCollectionUseCase() -> CreateCollectionUseCase
}

extension CreateCollectionUseCaseFactory {
    func makeCreateCollectionUseCase() -> CreateCollectionUseCase {
        return DefaultCreateCollectionUseCase(collectionRepository: makeCollectionRepository())
    }
}
