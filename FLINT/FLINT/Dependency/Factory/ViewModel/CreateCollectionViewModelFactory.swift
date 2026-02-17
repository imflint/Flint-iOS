//
//  CreateCollectionViewModel.swift
//  FLINT
//
//  Created by 김호성 on 2026.02.02.
//

import Foundation

import Presentation

protocol CreateCollectionViewModelFactory: CreateCollectionUseCaseFactory {
    func makeCreateCollectionViewModel() -> CreateCollectionViewModel
}

extension CreateCollectionViewModelFactory {
    func makeCreateCollectionViewModel() -> CreateCollectionViewModel {
        return DefaultCreateCollectionViewModel(createCollectionUseCase: makeCreateCollectionUseCase())
    }
}
