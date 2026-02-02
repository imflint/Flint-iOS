//
//  CreateCollectionViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension CreateCollectionViewControllerFactory where Self: CreateCollectionViewModelFactory & ViewControllerFactory {
    func makeCreateCollectionViewController() -> CreateCollectionViewController {
        let vm = makeCreateCollectionViewModel()
        return CreateCollectionViewController(viewModel: vm, viewControllerFactory: self)
    }
}
