//
//  RecalculateKeywordsUseCaseFactory.swift
//  FLINT
//
//  Created by 진소은 on 6/20/26.
//

import Foundation

import Domain

protocol RecalculateKeywordsUseCaseFactory: UserRepositoryFactory {
    func makeRecalculateKeywordsUseCase() -> RecalculateKeywordsUseCase
}

extension RecalculateKeywordsUseCaseFactory {
    func makeRecalculateKeywordsUseCase() -> RecalculateKeywordsUseCase {
        return DefaultRecalculateKeywordsUseCase(userRepository: makeUserRepository())
    }
}
