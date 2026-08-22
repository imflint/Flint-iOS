//
//  SavedCollectionListViewModel.swift
//  Presentation
//
//  Created by 진소은 on 2026/06/19.
//

import Combine
import Foundation

import Domain

public final class SavedCollectionListViewModel {

    // MARK: - Output
    @Published public private(set) var items: [CollectionEntity] = []

    // MARK: - Dependency
    private let target: UserTarget
    private let fetchBookmarkedCollectionsUseCase: FetchBookmarkedCollectionsUseCase
    private let toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    private var cancellables = Set<AnyCancellable>()

    public init(
        target: UserTarget,
        fetchBookmarkedCollectionsUseCase: FetchBookmarkedCollectionsUseCase,
        toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    ) {
        self.target = target
        self.fetchBookmarkedCollectionsUseCase = fetchBookmarkedCollectionsUseCase
        self.toggleCollectionBookmarkUseCase = toggleCollectionBookmarkUseCase
    }

    public func load() {
        fetchBookmarkedCollectionsUseCase(for: target)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchSavedCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)
    }

    public func updateBookmark(at index: Int, isBookmarked: Bool) {
        guard items.indices.contains(index) else { return }

        let old = items[index]
        guard let collectionIdInt = Int64(old.id) else { return }

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
                    print("toggleBookmark failed:", error)
                }
            } receiveValue: { isBookmarked in
                print("toggleBookmark success:", isBookmarked)
            }
            .store(in: &cancellables)
    }
}
