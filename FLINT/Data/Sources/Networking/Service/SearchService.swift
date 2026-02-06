//
//  SearchService.swift
//  Data
//
//  Created by 소은 on 1/20/26.
//

import Combine
import Foundation

import CombineMoya
import Moya

import DTO

public protocol SearchService {
    func searchContents(keyword: String?) -> AnyPublisher<SearchContentsDTO, Error>
}

public final class DefaultSearchService: SearchService {
    
    private let searchAPIProvider: MoyaProvider<SearchAPI>
    
    public init(searchAPIProvider: MoyaProvider<SearchAPI>) {
        self.searchAPIProvider = searchAPIProvider
    }
    
    public func searchContents(keyword: String?) -> AnyPublisher<SearchContentsDTO, Error> {
        searchAPIProvider.requestPublisher(.searchContents(keyword: keyword))
            .mapBaseResponseData(SearchContentsDTO.self)
    }
}

