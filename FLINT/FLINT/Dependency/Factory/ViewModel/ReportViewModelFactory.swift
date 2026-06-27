//
//  ReportViewModelFactory.swift
//  FLINT
//
//  Created by 소은 on 6/21/26.
//

import Foundation

import Presentation

protocol ReportViewModelFactory: ReportCollectionUseCaseFactory {
    func makeReportViewModel(collectionId: Int64) -> ReportViewModel
}

extension ReportViewModelFactory {
    func makeReportViewModel(collectionId: Int64) -> ReportViewModel {
        return ReportViewModel(reportCollectionUseCase: makeReportCollectionUseCase(), collectionId: collectionId)
    }
}
