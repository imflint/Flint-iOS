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
    func fetchSession()
    func indexUpdated(_ index: Int)
}

public protocol ExploreViewModelOutput {
    var index: CurrentValueSubject<Int, Never> { get }
    var collections: CurrentValueSubject<[ExploreInfoEntity], Never> { get }
    var cursor: CurrentValueSubject<Int64?, Never> { get set }
    
    var hasNext: Bool { get set }
}

public typealias ExploreViewModel = ExploreViewModelInput & ExploreViewModelOutput

public final class DefaultExploreViewModel: ExploreViewModel {
    
//    private let fetchExploreCollectionsUseCase: FetchExploreCollectionsUseCase
    private let fetchSessionUseCase: FetchSessionUseCase
    private let saveSessionProgressUseCase: SaveSessionProgressUseCase
    
    public var index: CurrentValueSubject<Int, Never> = .init(0)
    public var collections: CurrentValueSubject<[ExploreInfoEntity], Never> = .init([])
    public var cursor: CurrentValueSubject<Int64?, Never> = .init(nil)
    
    public var hasNext: Bool = false
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(fetchSessionUseCase: FetchSessionUseCase, saveSessionProgressUseCase: SaveSessionProgressUseCase) {
        self.fetchSessionUseCase = fetchSessionUseCase
        self.saveSessionProgressUseCase = saveSessionProgressUseCase
        bind()
//        fetchCollections()
        fetchSession()
    }
    
    public func indexUpdated(_ index: Int) {
        self.index.send(index)
        saveSessionProgressUseCase(lastViewedPosition: index)
            .manageThread()
            .sinkHandledCompletion { sessionEntity in
                Log.network.d(sessionEntity)
            }
            .store(in: &cancellables)
    }
    
    private func bind() {
//        index.sink { [weak self] index in
//            guard let self, let _ = cursor.value else { return }
//            if index > collections.value.count - 5 {
//                fetchCollections()
//            }
//        }
//        .store(in: &cancellables)
    }
    
    public func fetchSession() {
        fetchSessionUseCase()
            .manageThread()
            .sinkHandledCompletion { [weak self] sessionEntity in
                Log.network.d(sessionEntity)
                self?.hasNext = sessionEntity.hasNext
                self?.collections.send(sessionEntity.items)
                self?.index.send(sessionEntity.lastViewedPosition)
            }
            .store(in: &cancellables)
    }
    
//    private func fetchCollections() {
//        fetchExploreCollectionsUseCase(cursor: cursor.value)
//            .manageThread()
//            .sinkHandledCompletion { [weak self] collectionPagingEntity in
//                guard let self else { return }
//                collections.value.append(contentsOf: collectionPagingEntity.collections)
//                cursor.send(collectionPagingEntity.cursor)
//            }
//            .store(in: &cancellables)
//    }
    
    
}
