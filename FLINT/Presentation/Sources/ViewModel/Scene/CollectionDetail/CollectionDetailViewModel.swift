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
            bookmarkedUsers: CollectionBookmarkUsersEntity?,
            isOwner: Bool
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
    private let fetchProfileUseCase: FetchProfileUseCase
    private let deleteCollectionUseCase: DeleteCollectionUseCase
    private let toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase
    private let toggleContentBookmarkUseCase: ToggleContentBookmarkUseCase
    private let fetchBookmarkedContentCountUseCase: FetchBookmarkedContentCountUseCase

    // MARK: - Constant

    public static let minimumBookmarkCount = 5

    // MARK: - Private

    private let stateSubject = CurrentValueSubject<State, Never>(.idle)
    public let deleteSuccess = PassthroughSubject<Void, Never>()
    public let deleteFailure = PassthroughSubject<Error, Never>()
    /// 저장 취소가 최소 개수 제한에 걸림 (VC 에서 안내 모달 표시)
    /// - Payload: 시각 상태 원복이 필요한 콘텐츠 id
    public let contentBookmarkRemovalBlocked = PassthroughSubject<Int64, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(
        collectionId: Int64,
        fetchCollectionDetailUseCase: FetchCollectionDetailUseCase,
        fetchCollectionBookmarkUsersUseCase: FetchCollectionBookmarkUsersUseCase,
        fetchProfileUseCase: FetchProfileUseCase,
        deleteCollectionUseCase: DeleteCollectionUseCase,
        toggleCollectionBookmarkUseCase: ToggleCollectionBookmarkUseCase,
        toggleContentBookmarkUseCase: ToggleContentBookmarkUseCase,
        fetchBookmarkedContentCountUseCase: FetchBookmarkedContentCountUseCase
    ) {
        self.collectionId = collectionId
        self.fetchCollectionDetailUseCase = fetchCollectionDetailUseCase
        self.fetchCollectionBookmarkUsersUseCase = fetchCollectionBookmarkUsersUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.deleteCollectionUseCase = deleteCollectionUseCase
        self.toggleCollectionBookmarkUseCase = toggleCollectionBookmarkUseCase
        self.toggleContentBookmarkUseCase = toggleContentBookmarkUseCase
        self.fetchBookmarkedContentCountUseCase = fetchBookmarkedContentCountUseCase
    }

    // MARK: - Action

    public func deleteCollection() {
        deleteCollectionUseCase(collectionId: collectionId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.deleteFailure.send(error)
                    }
                },
                receiveValue: { [weak self] in
                    self?.deleteSuccess.send(())
                }
            )
            .store(in: &cancellables)
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

        // 본인 판별이 실패해도 상세는 보여줘야 하므로, myProfileId는 에러 시 nil로 대체
        let myProfileIdPublisher = fetchProfileUseCase(for: .me)
            .map { Optional($0.id) }
            .catch { _ in Just<String?>(nil).setFailureType(to: Error.self) }
            .eraseToAnyPublisher()

        Publishers.Zip(myProfileIdPublisher, fetchCollectionDetailUseCase(collectionId: collectionId))
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case let .failure(error) = completion {
                        self.stateSubject.send(.failed(error.localizedDescription))
                    }
                },
                receiveValue: { [weak self] myProfileId, detail in
                    guard let self else { return }
                    let isOwner = (myProfileId == detail.author.id)

                    self.stateSubject.send(.loaded(detail: detail, bookmarkedUsers: nil, isOwner: isOwner))

                    self.fetchCollectionBookmarkUsersUseCase(collectionId: self.collectionId)
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { [weak self] users in
                                guard let self else { return }
                                self.stateSubject.send(.loaded(detail: detail, bookmarkedUsers: users, isOwner: isOwner))
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
                receiveValue: { [weak self] _ in
                    self?.refreshBookmarkedUsers()
                }
            )
            .store(in: &cancellables)
    }

    private func refreshBookmarkedUsers() {
        guard case let .loaded(detail, _, isOwner) = stateSubject.value else { return }

        fetchCollectionBookmarkUsersUseCase(collectionId: collectionId)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] users in
                    guard let self else { return }
                    self.stateSubject.send(.loaded(detail: detail, bookmarkedUsers: users, isOwner: isOwner))
                }
            )
            .store(in: &cancellables)
    }

    private func toggleContentBookmark(contentId: Int64) {
        let isCurrentlyBookmarked = currentContentIsBookmarked(contentId: contentId)

        // 저장 → 저장 취소 흐름일 때만 최소 개수 가드 필요
        guard isCurrentlyBookmarked else {
            performContentBookmarkToggle(contentId: contentId)
            return
        }

        fetchBookmarkedContentCountUseCase()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchBookmarkedContentCount failed:", error)
                }
            } receiveValue: { [weak self] count in
                guard let self else { return }
                if count <= Self.minimumBookmarkCount {
                    self.contentBookmarkRemovalBlocked.send(contentId)
                } else {
                    self.performContentBookmarkToggle(contentId: contentId)
                }
            }
            .store(in: &cancellables)
    }

    private func performContentBookmarkToggle(contentId: Int64) {
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

    private func currentContentIsBookmarked(contentId: Int64) -> Bool {
        guard case let .loaded(detail, _, _) = stateSubject.value else { return false }
        return detail.contents.first { Int64($0.id) == contentId }?.isBookmarked ?? false
    }
}
