//
//  ToggleContentBookmarkUseCase.swift
//  Domain
//
//  Created by 소은 on 1/21/26.
//

import Combine
import Foundation

import Entity
import Repository

public protocol ToggleContentBookmarkUseCase {
    func toggleContentBookmark(_ contentId: Int64) -> AnyPublisher<Bool, Error>
}

public class DefaultToggleContentBookmarkUseCase: ToggleContentBookmarkUseCase {

    let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func toggleContentBookmark(_ contentId: Int64) -> AnyPublisher<Bool, Error> {
        return repository.toggleContentBookmark(contentId)
    }
}
