//
//  HomeRepository.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import Entity


public protocol HomeRepository {
    func fetchRecommendedCollections() -> AnyPublisher<[CollectionInfoEntity], Error>
}

