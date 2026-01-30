//
//  CollectionDetailViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension CollectionDetailViewControllerFactory where Self: CollectionDetailFactory & ViewControllerFactory {
    func makeCollectionDetailViewController(collectionId: Int64) -> CollectionDetailViewController {
        return CollectionDetailViewController(viewModel: makeCollectionDetailViewModel(collectionId: collectionId), viewControllerFactory: self)
    }
}
