//
//  HomeViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import Foundation
import Combine

import Domain

// MARK: - Protocol

public protocol HomeViewModelInput {
    func fetchRecommendedCollections()
    func fetchRecentCollections()
}

public protocol HomeViewModelOutput {
    
    var homeRecommendedCollections: CurrentValueSubject<[CollectionInfoEntity], Never> { get }
    var recentCollections: CurrentValueSubject<[RecentCollectionEntity], Never> { get }
}

public typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

public final class DefaultHomeViewModel: HomeViewModel {
    
    private let homeUseCase: HomeUseCase
    private let fetchRecentCollectionsUseCase: FetchRecentCollectionsUseCase
    
    // MARK: - Output
    
    public var homeRecommendedCollections: CurrentValueSubject<[CollectionInfoEntity], Never> = .init([])
    public var recentCollections: CurrentValueSubject<[RecentCollectionEntity], Never> = .init([])
    
    // MARK: - Combine
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    public init(
        homeUseCase: HomeUseCase,
        fetchRecentCollectionsUseCase: FetchRecentCollectionsUseCase
    ) {
        self.homeUseCase = homeUseCase
        self.fetchRecentCollectionsUseCase = fetchRecentCollectionsUseCase
        
    }
    
    // MARK: - Input
    
    public func fetchRecommendedCollections() {
        homeUseCase.fetchRecommendedCollections()
            .manageThread()
            .sinkHandledCompletion { [weak self] entity in
                self?.homeRecommendedCollections.send(entity)
            }
            .store(in: &cancellables)
    }
    
    public func fetchRecentCollections() {
        fetchRecentCollectionsUseCase.fetchRecentCollections()
            .manageThread()
            .sinkHandledCompletion { [weak self] entity in
                self?.recentCollections.send(entity)
            }
            .store(in: &cancellables)
    }
}

