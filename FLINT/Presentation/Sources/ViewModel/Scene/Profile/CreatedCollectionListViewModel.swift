//
//  CreatedCollectionListViewModel.swift
//  Presentation
//
//  Created by 진소은 on 8/20/26.
//

import Combine
import Foundation

import Domain

public final class CreatedCollectionListViewModel {

    // MARK: - Output
    @Published public private(set) var items: [CollectionEntity] = []

    // MARK: - Dependency
    private let target: UserTarget
    private let fetchCreatedCollectionsUseCase: FetchCreatedCollectionsUseCase
    private let toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    private var cancellables = Set<AnyCancellable>()

    public init(
        target: UserTarget,
        fetchCreatedCollectionsUseCase: FetchCreatedCollectionsUseCase,
        toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    ) {
        self.target = target
        self.fetchCreatedCollectionsUseCase = fetchCreatedCollectionsUseCase
        self.toggleCollectionBookmarkUseCase = toggleCollectionBookmarkUseCase
    }

    public func load() {
        fetchCreatedCollectionsUseCase(for: target)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchCreatedCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)
    }

    public func updateBookmark(at index: Int, isBookmarked: Bool) {
        guard items.indices.contains(index) else { return }

        let old = items[index]
        guard let collectionId = Int64(old.id) else { return }

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

        toggleCollectionBookmarkUseCase(collectionId: collectionId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("toggleCollectionBookmark failed:", error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
