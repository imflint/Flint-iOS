//
//  CollectionRepository.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Entity

public protocol CollectionRepository {
    func createCollection(_ entity: CreateCollectionEntity) -> AnyPublisher<Void, NetworkError>
}
