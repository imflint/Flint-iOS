//
//  CollectionDetailViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension CollectionDetailViewControllerFactory where Self: CollectionDetailViewModelFactory & ViewControllerFactory {
    func makeCollectionDetailViewController(collectionId: Int64) -> CollectionDetailViewController {
        let vc = CollectionDetailViewController(viewModel: makeCollectionDetailViewModel(collectionId: collectionId), viewControllerFactory: self)
        vc.onTapReport = { collectionId in
            let reportVC = vc.viewControllerFactory?.makeReportViewController(collectionId: collectionId)
        }
        return vc
    }
}
