//
//  CollectionDetailViewModel.swift
//  Presentation
//
//  Created by 진소은 on 1/23/26.
//

import Combine
import Foundation

import Domain

public final class CollectionDetailViewModel {

    // MARK: - State

    public enum State: Equatable {
        case idle
        case loading
        case loaded(
            detail: CollectionDetailEntity,
            bookmarkedUsers: CollectionBookmarkUsersEntity?
        )
        case failed(String)
    }

    // MARK: - Input

    public struct Input {
        public let viewDidLoad: AnyPublisher<Void, Never>
        public let tapHeaderSave: AnyPublisher<Bool, Never> // 토글 결과(isSaved)
        public let tapContentBookmark: AnyPublisher<Int64, Never> // 토글된 콘텐츠 ID
        public init(
            viewDidLoad: AnyPublisher<Void, Never>,
            tapHeaderSave: AnyPublisher<Bool, Never>,
            tapContentBookmark: AnyPublisher<Int64, Never>
        ) {
            self.viewDidLoad = viewDidLoad
            self.tapHeaderSave = tapHeaderSave
            self.tapContentBookmark = tapContentBookmark
        }
    }

    // MARK: - Output

    public struct Output {
        public let state: AnyPublisher<State, Never>
        public init(state: AnyPublisher<State, Never>) {
            self.state = state
        }
    }

    // MARK: - Dependency

    private let collectionId: Int64
    private let fetchCollectionDetailUseCase: FetchCollectionDetailUseCase
    private let fetchCollectionBookmarkUsersUseCase: FetchCollectionBookmarkUsersUseCase
    private let toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    private let toggleContentBookmarkUseCase: ToggleContentBookmarkUseCase

    // MARK: - Private

    private let stateSubject = CurrentValueSubject<State, Never>(.idle)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(
        collectionId: Int64,
        fetchCollectionDetailUseCase: FetchCollectionDetailUseCase,
        fetchCollectionBookmarkUsersUseCase: FetchCollectionBookmarkUsersUseCase,
        toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase,
        toggleContentBookmarkUseCase: ToggleContentBookmarkUseCase
    ) {
        self.collectionId = collectionId
        self.fetchCollectionDetailUseCase = fetchCollectionDetailUseCase
        self.fetchCollectionBookmarkUsersUseCase = fetchCollectionBookmarkUsersUseCase
        self.toggleCollectionBookmarkUseCase = toggleCollectionBookmarkUseCase
        self.toggleContentBookmarkUseCase = toggleContentBookmarkUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {

        input.viewDidLoad
            .sink { [weak self] in
                self?.fetch()
            }
            .store(in: &cancellables)

        input.tapHeaderSave
            .sink { [weak self] _ in
                self?.toggleCollectionBookmark()
            }
            .store(in: &cancellables)

        input.tapContentBookmark
            .sink { [weak self] contentId in
                self?.toggleContentBookmark(contentId: contentId)
            }
            .store(in: &cancellables)

        return Output(
            state: stateSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Fetch
    private func fetch() {
        stateSubject.send(.loading)

        fetchCollectionDetailUseCase(collectionId: collectionId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case let .failure(error) = completion {
                        self.stateSubject.send(.failed(error.localizedDescription))
                    }
                },
                receiveValue: { [weak self] detail in
                    guard let self else { return }

                    self.stateSubject.send(.loaded(detail: detail, bookmarkedUsers: nil))

                    self.fetchCollectionBookmarkUsersUseCase(collectionId: self.collectionId)
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { [weak self] users in
                                guard let self else { return }
                                self.stateSubject.send(.loaded(detail: detail, bookmarkedUsers: users))
                            }
                        )
                        .store(in: &self.cancellables)
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - Toggle

    private func toggleCollectionBookmark() {
        toggleCollectionBookmarkUseCase(collectionId: collectionId)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("toggleCollectionBookmark failed:", error)
                    }
                },
                receiveValue: { isBookmarked in
                    print("toggleCollectionBookmark success:", isBookmarked)
                }
            )
            .store(in: &cancellables)
    }

    private func toggleContentBookmark(contentId: Int64) {
        toggleContentBookmarkUseCase(contentId: contentId)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("toggleContentBookmark failed:", error)
                    }
                },
                receiveValue: { isBookmarked in
                    print("toggleContentBookmark success:", isBookmarked)
                }
            )
            .store(in: &cancellables)
    }
}
