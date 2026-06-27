//
//  UpdateCollectionUseCaseFactory.swift
//  FLINT
//
//  Created by 진소은 on 6/21/26.
//

import Foundation

import Domain

protocol UpdateCollectionUseCaseFactory: CollectionRepositoryFactory {
    func makeUpdateCollectionUseCase() -> UpdateCollectionUseCase
}

extension UpdateCollectionUseCaseFactory {
    func makeUpdateCollectionUseCase() -> UpdateCollectionUseCase {
        return DefaultUpdateCollectionUseCase(collectionRepository: makeCollectionRepository())
    }
}
