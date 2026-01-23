//
//  File.swift
//  Presentation
//
//  Created by 김호성 on 2026.01.22.
//

import Combine
import Foundation

import Domain

public protocol ExploreViewModelInput {
    func indexUpdated(_ index: Int)
}

public protocol ExploreViewModelOutput {
    var index: CurrentValueSubject<Int, Never> { get }
    var collections: CurrentValueSubject<[CollectionInfoEntity], Never> { get }
    var cursor: UInt? { get set }
}

public typealias ExploreViewModel = ExploreViewModelInput & ExploreViewModelOutput

public final class DefaultExploreViewModel: ExploreViewModel {
    
    private let exploreUseCase: ExploreUseCase
    
    public var index: CurrentValueSubject<Int, Never> = .init(0)
    public var collections: CurrentValueSubject<[Entity.CollectionInfoEntity], Never> = .init([])
    public var cursor: UInt?
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(exploreUseCase: ExploreUseCase) {
        self.exploreUseCase = exploreUseCase
        bind()
        fetchCollections()
    }
    
    public func indexUpdated(_ index: Int) {
        self.index.send(index)
    }
    
    private func bind() {
        index.sink { [weak self] index in
            guard let self else { return }
            if index > collections.value.count - 3 {
                fetchCollections()
            }
        }
        .store(in: &cancellables)
    }
    
    private func fetchCollections() {
        exploreUseCase.fetchExplore(cursor: cursor)
            .manageThread()
            .sinkHandledCompletion { [weak self] collectionPagingEntity in
                guard let self else { return }
                collections.value.append(contentsOf: collectionPagingEntity.collections)
                cursor = collectionPagingEntity.cursor
            }
            .store(in: &cancellables)
    }
}
