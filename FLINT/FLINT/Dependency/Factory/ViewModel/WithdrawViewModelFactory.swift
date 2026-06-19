//
//  WithdrawViewModelFactory.swift
//  FLINT
//
//  Created by 소은 on 6/19/26.
//

import Foundation
import Presentation

protocol WithdrawViewModelFactory: WithDrawUseCaseFactory {
    func makeWithdrawViewModel() -> WithdrawViewModel
}

extension WithdrawViewModelFactory {
    func makeWithdrawViewModel() -> WithdrawViewModel {
        return WithdrawViewModel(withDrawUseCase: makeWithDrawUseCase())
    }
}
