//
//  CreateCollectionViewModelFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Presentation

protocol CreateCollectionViewModelFactory: CreateCollectionUseCaseFactory, UpdateCollectionUseCaseFactory, UploadCollectionImageUseCaseFactory {
    func makeCreateCollectionViewModel(mode: CreateCollectionMode) -> CreateCollectionViewModel
}

extension CreateCollectionViewModelFactory {
    func makeCreateCollectionViewModel(mode: CreateCollectionMode = .create) -> CreateCollectionViewModel {
        return DefaultCreateCollectionViewModel(
            mode: mode,
            createCollectionUseCase: makeCreateCollectionUseCase(),
            updateCollectionUseCase: makeUpdateCollectionUseCase(),
            uploadImageUseCase: makeUploadCollectionImageUseCase()
        )
    }
}
