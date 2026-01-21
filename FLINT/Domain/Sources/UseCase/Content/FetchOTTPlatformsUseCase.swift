//
//  FetchOTTPlatformsUseCase.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol FetchOTTPlatformsUseCase {
    func fetchOTTPlatforms(_ contentId: Int64) -> AnyPublisher<FetchOTTPlatformsEntity, NetworkError>
}

public class DefaultFetchOTTPlatformsUseCase: FetchOTTPlatformsUseCase {
    
    private let contentRepository: ContentRepository
    
    public init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }
    
    public func fetchOTTPlatforms(_ contentId: Int64) -> AnyPublisher<FetchOTTPlatformsEntity, NetworkError> {
        return contentRepository.fetchOTTPlatforms(contentId)
    }
}
