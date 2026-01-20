//
//  BookmarkRepository.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity

public protocol BookmarkRepository {
    func toggleCollectionBookmark(_ collectionId: Int64) -> AnyPublisher<Bool, NetworkError>
    
    func toggleContentBookmark(_ contentId: Int64) -> AnyPublisher<Bool, NetworkError>
}
