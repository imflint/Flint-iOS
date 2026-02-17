//
//  FetchOTTPlatformsForContentUseCase.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchOTTPlatformsForContentUseCase {
    func callAsFunction(contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error>
}

public class DefaultFetchOTTPlatformsForContentUseCase: FetchOTTPlatformsForContentUseCase {
    
    private let contentRepository: ContentRepository
    
    public init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }
    
    public func callAsFunction(contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error> {
        return contentRepository.fetchOTTPlatformsForContent(contentId: contentId)
    }
}
