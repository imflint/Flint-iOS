//
//  ReportViewControllerFactory+.swift
//  FLINT
//

import Foundation

import Presentation

extension ReportViewControllerFactory where Self: ReportViewModelFactory & ViewControllerFactory {
    func makeReportViewController(collectionId: Int64) -> ReportViewController {
        return ReportViewController(
            viewModel: makeReportViewModel(collectionId: collectionId),
            viewControllerFactory: self
        )
    }
}
