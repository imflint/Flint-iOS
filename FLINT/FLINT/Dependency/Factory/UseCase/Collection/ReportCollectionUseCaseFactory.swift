//
//  ReportCollectionUseCaseFactory.swift
//  FLINT
//
//  Created by 소은 on 6/21/26.
//

import Foundation

import Domain

protocol ReportCollectionUseCaseFactory: CollectionRepositoryFactory {
    func makeReportCollectionUseCase() -> ReportCollectionUseCase
}

extension ReportCollectionUseCaseFactory {
    func makeReportCollectionUseCase() -> ReportCollectionUseCase {
        return DefaultReportCollectionUseCase(collectionRepository: makeCollectionRepository())
    }
}
