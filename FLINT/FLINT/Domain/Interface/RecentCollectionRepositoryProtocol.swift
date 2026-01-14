//
//  RecentCollectionRepositoryProtocol.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import Combine

protocol RecentCollectionRepositoryProtocol {
    
    func fetchRecentCollections() -> AnyPublisher<[RecentCollectionItemEntity], Error>
}
