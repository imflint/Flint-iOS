//
//  CollectionFolderListViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/24/26.
//

import Foundation
import Combine

import Domain
import Entity

public final class CollectionFolderListViewModel {

    // MARK: - Output
    @Published public private(set) var items: [CollectionEntity] = []

    // MARK: - Dependency
    private let fetchPopularCollectionsUseCase: FetchPopularCollectionsUseCase
    private let toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    private var cancellables = Set<AnyCancellable>()

    public init(
        fetchPopularCollectionsUseCase: FetchPopularCollectionsUseCase,
        toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    ) {
        self.fetchPopularCollectionsUseCase = fetchPopularCollectionsUseCase
        self.toggleCollectionBookmarkUseCase = toggleCollectionBookmarkUseCase
    }

    public func load() {
        fetchPopularCollectionsUseCase() 
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ fetchPopularCollections failed:", error)  
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }
                self.items = items
            }
            .store(in: &cancellables)
    }
    
    public func updateBookmark(at index: Int, isBookmarked: Bool) {
        
        guard items.indices.contains(index) else { return }

        let old = items[index]
        
        let collectionId = old.id
        guard let collectionIdInt = Int64(collectionId) else { return }

        items[index] = CollectionEntity(
            id: old.id,
            thumbnailUrl: old.thumbnailUrl,
            title: old.title,
            description: old.description,
            imageList: old.imageList,
            bookmarkCount: isBookmarked ? old.bookmarkCount + 1 : max(old.bookmarkCount - 1, 0),
            isBookmarked: isBookmarked,
            user: old.user
        )
        
        toggleCollectionBookmarkUseCase(collectionId: collectionIdInt)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ toggleBookmark failed:", error)
                }
            } receiveValue: { isBookmarked in
                print("✅ toggleBookmark success:", isBookmarked)
            }
            .store(in: &cancellables)
    }

}
