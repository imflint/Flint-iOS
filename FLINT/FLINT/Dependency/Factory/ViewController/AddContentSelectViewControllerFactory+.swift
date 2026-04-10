//
//  AddContentSelectViewControllerFactory+.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.31.
//

import Foundation

import Presentation

extension AddContentSelectViewControllerFactory where Self: AddContentSelectViewModelFactory & ViewControllerFactory {
    func makeAddContentSelectViewController() -> AddContentSelectViewController {
        let vm = makeAddContentSelectViewModel()
        return AddContentSelectViewController(viewModel: vm, viewControllerFactory: self)
    }
}
