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
    private let fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase
    private var cancellables = Set<AnyCancellable>()

    public init(fetchWatchingCollectionsUseCase: FetchWatchingCollectionsUseCase) {
        self.fetchWatchingCollectionsUseCase = fetchWatchingCollectionsUseCase
    }

    public func load() {
        fetchWatchingCollectionsUseCase.fetchWatchingCollections()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ watching collections failed:", error)
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

        items[index] = CollectionEntity(
            id: old.id,
            thumbnailUrl: old.thumbnailUrl,
            title: old.title,
            description: old.description,
            imageList: old.imageList,
            bookmarkCount: old.bookmarkCount,
            isBookmarked: isBookmarked,  
            userId: old.userId,
            nickname: old.nickname,
            profileImageUrl: old.profileImageUrl
        )
    }

}

