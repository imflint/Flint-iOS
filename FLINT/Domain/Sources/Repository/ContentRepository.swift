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
    func fetchMyBookmarkedContents() -> AnyPublisher<[ContentInfoEntity], Error>
    func fetchOTTPlatformsForContent(contentId: Int64) -> AnyPublisher<[OTTPlatformEntity], Error>
}
