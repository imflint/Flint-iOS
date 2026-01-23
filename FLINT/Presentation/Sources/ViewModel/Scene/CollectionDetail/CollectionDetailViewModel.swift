//
//  CollectionDetailViewModel.swift
//  Presentation
//
//  Created by 진소은 on 1/23/26.
//

import Combine
import Foundation

import Domain
import Entity

public final class CollectionDetailViewModel {

    // MARK: - State

    public enum State: Equatable {
        case idle
        case loading
        case loaded(CollectionDetailEntity)
        case failed(String)
    }

    // MARK: - Input

    public struct Input {
        public let viewDidLoad: AnyPublisher<Void, Never>
        public let tapHeaderSave: AnyPublisher<Bool, Never> // 토글 결과(isSaved)
        public init(
            viewDidLoad: AnyPublisher<Void, Never>,
            tapHeaderSave: AnyPublisher<Bool, Never>
        ) {
            self.viewDidLoad = viewDidLoad
            self.tapHeaderSave = tapHeaderSave
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
    private let collectionDetailUseCase: CollectionDetailUseCase

    // MARK: - Private

    private let stateSubject = CurrentValueSubject<State, Never>(.idle)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(
        collectionId: Int64,
        collectionDetailUseCase: CollectionDetailUseCase
    ) {
        self.collectionId = collectionId
        self.collectionDetailUseCase = collectionDetailUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {

        input.viewDidLoad
            .sink { [weak self] in
                self?.fetch()
            }
            .store(in: &cancellables)

        // 지금 단계에선 “저장 토글” API가 없으니 print 처리만.
        // (추후 BookmarkUseCase 붙이면 여기서 처리)
        input.tapHeaderSave
            .sink { isSaved in
                print("Header save tapped:", isSaved)
            }
            .store(in: &cancellables)

        return Output(
            state: stateSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Fetch

    private func fetch() {
        stateSubject.send(.loading)

        collectionDetailUseCase.fetchCollectionDetail(collectionId: collectionId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case let .failure(error) = completion {
                        self.stateSubject.send(.failed(error.localizedDescription))
                    }
                },
                receiveValue: { [weak self] entity in
                    self?.stateSubject.send(.loaded(entity))
                }
            )
            .store(in: &cancellables)
    }
}
