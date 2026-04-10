//
//  ExploreViewModel.swift
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
    var collections: CurrentValueSubject<[ExploreInfoEntity], Never> { get }
    var cursor: CurrentValueSubject<Int64?, Never> { get set }
}

public typealias ExploreViewModel = ExploreViewModelInput & ExploreViewModelOutput

public final class DefaultExploreViewModel: ExploreViewModel {
    
    private let fetchExploreCollectionsUseCase: FetchExploreCollectionsUseCase
    
    public var index: CurrentValueSubject<Int, Never> = .init(0)
    public var collections: CurrentValueSubject<[ExploreInfoEntity], Never> = .init([])
    public var cursor: CurrentValueSubject<Int64?, Never> = .init(nil)
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(fetchExploreCollectionsUseCase: FetchExploreCollectionsUseCase) {
        self.fetchExploreCollectionsUseCase = fetchExploreCollectionsUseCase
        bind()
        fetchCollections()
    }
    
    public func indexUpdated(_ index: Int) {
        self.index.send(index)
    }
    
    private func bind() {
        index.sink { [weak self] index in
            guard let self, let _ = cursor.value else { return }
            if index > collections.value.count - 5 {
                fetchCollections()
            }
        }
        .store(in: &cancellables)
    }
    
    private func fetchCollections() {
        fetchExploreCollectionsUseCase(cursor: cursor.value)
            .manageThread()
            .sinkHandledCompletion { [weak self] collectionPagingEntity in
                guard let self else { return }
                collections.value.append(contentsOf: collectionPagingEntity.collections)
                cursor.send(collectionPagingEntity.cursor)
            }
            .store(in: &cancellables)
    }
}
