//
//  ReportCollectionUseCase.swift
//  Domain
//
//  Created by 소은 on 6/21/26.
//

import Combine
import Foundation

import Repository

public protocol ReportCollectionUseCase {
    func callAsFunction(collectionId: Int64, reasons: [String], otherDetail: String?) -> AnyPublisher<Void, Error>
}

public final class DefaultReportCollectionUseCase: ReportCollectionUseCase {
    
    private let collectionRepository: CollectionRepository
    
    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }
    
    public func callAsFunction(collectionId: Int64, reasons: [String], otherDetail: String?) -> AnyPublisher<Void, Error> {
        return collectionRepository.reportCollection(collectionId: collectionId, reasons: reasons, otherDetail: otherDetail)
    }
}
