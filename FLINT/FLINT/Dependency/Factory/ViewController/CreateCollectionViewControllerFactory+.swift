//
//  CreateCollectionViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Domain
import Presentation

extension CreateCollectionViewControllerFactory where Self: CreateCollectionViewModelFactory & ViewControllerFactory {
    func makeCreateCollectionViewController() -> CreateCollectionViewController {
        let vm = makeCreateCollectionViewModel(mode: .create)
        return CreateCollectionViewController(
            mode: .create,
            viewModel: vm,
            viewControllerFactory: self
        )
    }

    func makeEditCollectionViewController(collectionId: Int64, prefill: CollectionDetailEntity) -> CreateCollectionViewController {
        let mode: CreateCollectionMode = .edit(collectionId: collectionId)
        let vm = makeCreateCollectionViewModel(mode: mode)
        let vc = CreateCollectionViewController(
            mode: mode,
            viewModel: vm,
            viewControllerFactory: self
        )
        vc.prefill(from: prefill)
        return vc
    }
}
