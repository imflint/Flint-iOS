//
//  RecentCollectionUseCaseProtocol.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import Combine

protocol RecentCollectionUseCaseProtocol {
    
    func fetchRecentCollections() -> AnyPublisher<[RecentCollectionItemEntity], Error>
}
