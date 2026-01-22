//
//  SearchContentsRepository.swift
//  Domain
//
//  Created by 소은 on 1/20/26.
//

import Combine

import Entity

public protocol SearchRepository {
    func searchContents(_ keyword: String?) -> AnyPublisher<[ContentEntity], Error>
}
