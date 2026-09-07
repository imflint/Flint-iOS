//
//  WithdrawalCompleteViewControllerFactory+.swift
//  FLINT
//
//  Created by 진소은 on 9/6/26.
//

import Foundation

import Presentation

extension WithdrawalCompleteViewControllerFactory where Self: ViewControllerFactory {
    func makeWithdrawalCompleteViewController() -> WithdrawalCompleteViewController {
        return WithdrawalCompleteViewController(viewControllerFactory: self)
    }
}
