//
//  DeleteCollectionUseCaseFactory.swift
//  FLINT
//
//  Created by 진소은 on 6/21/26.
//

import Foundation

import Domain

protocol DeleteCollectionUseCaseFactory: CollectionRepositoryFactory {
    func makeDeleteCollectionUseCase() -> DeleteCollectionUseCase
}

extension DeleteCollectionUseCaseFactory {
    func makeDeleteCollectionUseCase() -> DeleteCollectionUseCase {
        return DefaultDeleteCollectionUseCase(collectionRepository: makeCollectionRepository())
    }
}
