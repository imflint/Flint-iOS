//
//  CreateCollectionViewModel.swift
//  Presentation
//
//  Created by 소은 on 2026.01.22.
//

import Combine
import Foundation

import Domain

// MARK: - Protocol

public protocol CreateCollectionViewModelInput {
    func updateTitle(_ title: String)
    func updateVisibility(_ isPublic: Bool)
    func updateSelectedCount(_ count: Int)
    func updateCreateCollectionEntity(_ entity: CreateCollectionEntity)
    func createCollection()
}

public protocol CreateCollectionViewModelOutput {
    var isDoneEnabled: CurrentValueSubject<Bool, Never> { get }
    var createSuccess: PassthroughSubject<Void, Never> { get }
    var createFailure: PassthroughSubject<Error, Never> { get }
}

public typealias CreateCollectionViewModel = CreateCollectionViewModelInput & CreateCollectionViewModelOutput

// MARK: - Default

public final class DefaultCreateCollectionViewModel: CreateCollectionViewModel {

    // MARK: - Dependency

    private let createCollectionUseCase: CreateCollectionUseCase

    // MARK: - Output

    public var isDoneEnabled: CurrentValueSubject<Bool, Never> = .init(false)
    public var createSuccess: PassthroughSubject<Void, Never> = .init()
    public var createFailure: PassthroughSubject<Error, Never> = .init()

    // MARK: - State

    private var title: String = ""
    private var isPublic: Bool = false
    private var selectedCount: Int = 0
    private var createEntity: CreateCollectionEntity?

    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    // MARK: - Init

    public init(createCollectionUseCase: CreateCollectionUseCase) {
        self.createCollectionUseCase = createCollectionUseCase
    }

    // MARK: - Input

    public func updateTitle(_ title: String) {
        self.title = title
        evaluateDoneEnabled()
    }

    public func updateVisibility(_ isPublic: Bool) {
        self.isPublic = isPublic
        evaluateDoneEnabled()
    }

    public func updateSelectedCount(_ count: Int) {
        self.selectedCount = count
        evaluateDoneEnabled()
    }

    public func updateCreateCollectionEntity(_ entity: CreateCollectionEntity) {
        self.createEntity = entity
        // Entity 업데이트가 곧 enable 조건을 바꾸진 않지만, 정책상 필요하면 여기서도 평가 가능
        evaluateDoneEnabled()
    }

    public func createCollection() {
        guard isDoneEnabled.value else { return }
        guard let entity = createEntity else { return }

        createCollectionUseCase.createCollection(entity)
            .manageThread()
            .map { Result<Void, Error>.success(()) }
            .catch { Just(Result<Void, Error>.failure($0)) }
            .sinkHandledCompletion { [weak self] result in
                switch result {
                case .success:
                    self?.createSuccess.send(())
                case .failure(let error):
                    self?.createFailure.send(error)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Private

    private func evaluateDoneEnabled() {
        let titleValid = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let countValid = selectedCount >= 2
        let visibilityValid = isPublic == true
        let entityValid = (createEntity != nil)

        isDoneEnabled.send(titleValid && countValid && visibilityValid && entityValid)
    }
}
