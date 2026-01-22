//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2026.01.22.
//

import Combine
import Foundation

import Entity
import Repository

public protocol ContentsUseCase {
    func fetchContents() -> AnyPublisher<[ContentEntity], Error>
}

public class DefaultContentsUseCase: ContentsUseCase {
    
    private let searchRepository: SearchRepository
    
    public init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    public func fetchContents() -> AnyPublisher<[ContentEntity], Error> {
        return searchRepository.searchContents(nil)
    }
}
