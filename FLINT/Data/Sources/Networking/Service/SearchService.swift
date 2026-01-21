//
//  SearchContentsService.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

import Domain

import DTO

public protocol SearchService {
    func searchContents(
        _ query: String) -> AnyPublisher<SearchContentsDTO, NetworkError>
}

public final class DefaultSearchService: SearchService {
    
    private let provider = MoyaProvider<SearchAPI>()
    
    public init() {
        
    }
    
    public func searchContents(_ keyword: String) -> AnyPublisher<DTO.SearchContentsDTO, Entity.NetworkError> {
        provider.requestPublisher(.searchContents(keyword))
            .extractData(SearchContentsDTO.self)
    }
        
}

