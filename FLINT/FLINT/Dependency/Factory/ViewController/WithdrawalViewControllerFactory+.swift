//
//  WithdrawalViewControllerFactory+.swift
//  FLINT
//
//  Created by 소은 on 6/19/26.
//

import Foundation

import Presentation

extension WithdrawalViewControllerFactory where Self: WithdrawViewModelFactory & ViewControllerFactory {
    func makeWithdrawalViewController() -> WithdrawalViewController {
        return WithdrawalViewController(
            viewModel: makeWithdrawViewModel(),
            viewControllerFactory: self
        )
    }
}
