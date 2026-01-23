//
//  CreateCollectionFactory.swift
//  FLINT
//

import Foundation
import Moya

import Data
import Domain
import Presentation

protocol CreateCollectionFactory: CollectionRepositoryFactory {

    // UseCase
    func makeCreateCollectionUseCase() -> CreateCollectionUseCase
    func makeCreateCollectionUseCase(collectionRepository: CollectionRepository) -> CreateCollectionUseCase

    // ViewModel
    func makeCreateCollectionViewModel() -> CreateCollectionViewModel
    func makeCreateCollectionViewModel(createCollectionUseCase: CreateCollectionUseCase) -> CreateCollectionViewModel
}

extension CreateCollectionFactory {

    func makeCreateCollectionUseCase() -> CreateCollectionUseCase {
        return makeCreateCollectionUseCase(collectionRepository: makeCollectionRepository())
    }

    func makeCreateCollectionUseCase(collectionRepository: CollectionRepository) -> CreateCollectionUseCase {
        return DefaultCreateCollectionUseCase(collectionRepository: collectionRepository)
    }

    func makeCreateCollectionViewModel() -> CreateCollectionViewModel {
        return makeCreateCollectionViewModel(createCollectionUseCase: makeCreateCollectionUseCase())
    }

    func makeCreateCollectionViewModel(createCollectionUseCase: CreateCollectionUseCase) -> CreateCollectionViewModel {
        return DefaultCreateCollectionViewModel(createCollectionUseCase: createCollectionUseCase)
    }
}
