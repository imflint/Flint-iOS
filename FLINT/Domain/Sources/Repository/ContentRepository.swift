//
//  ContentRepository.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity

public protocol ContentRepository {
<<<<<<< HEAD
    func fetchOTTPlatforms(_ contentId: Int64) -> AnyPublisher<FetchOTTPlatformsEntity, NetworkError>
    func fetchBookmarkedContents() -> AnyPublisher<BookmarkContentsListEntity, NetworkError>
=======
    func fetchOTTPlatforms(_ contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error>
>>>>>>> origin/develop
}
