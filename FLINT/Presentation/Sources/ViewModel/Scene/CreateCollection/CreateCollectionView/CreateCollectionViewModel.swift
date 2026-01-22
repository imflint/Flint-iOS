//
//  CreateCollectionViewModel.swift
//  Presentation
//
//  Created by 소은 on 2026.01.22.
//

import Combine
import Foundation

import Domain

public protocol CreateCollectionViewModelInput {
    func updateTitle(_ title: String)
    func updateDescription(_ description: String)
    func updateVisibility(_ isPublic: Bool)
    func updateContentList(_ list: [CreateCollectionEntity.CreateCollectionContents])
    func createCollection()
}

public protocol CreateCollectionViewModelOutput {
    var isDoneEnabled: CurrentValueSubject<Bool, Never> { get }
    var createSuccess: PassthroughSubject<Void, Never> { get }
    var createFailure: PassthroughSubject<Error, Never> { get }
}

public typealias CreateCollectionViewModel = CreateCollectionViewModelInput & CreateCollectionViewModelOutput

public final class DefaultCreateCollectionViewModel: CreateCollectionViewModel {

    private let createCollectionUseCase: CreateCollectionUseCase

    public var isDoneEnabled: CurrentValueSubject<Bool, Never> = .init(false)
    public var createSuccess: PassthroughSubject<Void, Never> = .init()
    public var createFailure: PassthroughSubject<Error, Never> = .init()

    // MARK: - State
    private var imageUrl: String = ""
    private var titleText: String = ""
    private var descriptionText: String = ""
    private var isPublic: Bool = false
    private var contentList: [CreateCollectionEntity.CreateCollectionContents] = []

    private var createEntity: CreateCollectionEntity?
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    public init(createCollectionUseCase: CreateCollectionUseCase) {
        self.createCollectionUseCase = createCollectionUseCase
    }

    // MARK: - Input
    public func updateTitle(_ title: String) {
        self.titleText = title
        evaluateDoneEnabled()
    }

    public func updateDescription(_ description: String) {
        self.descriptionText = description
        evaluateDoneEnabled()
    }

    public func updateVisibility(_ isPublic: Bool) {
        self.isPublic = isPublic
        evaluateDoneEnabled()
    }

    public func updateContentList(_ list: [CreateCollectionEntity.CreateCollectionContents]) {
        self.contentList = list
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
        let titleValid = !titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let countValid = contentList.count >= 2
        let visibilityValid = isPublic == true  // (정책 나중에)
        let descriptionValid = true             // (정책 나중에)
        let imageValid = true                   // (정책 나중에)

        let canCreate = titleValid && countValid && visibilityValid && descriptionValid && imageValid

        if canCreate {
            createEntity = CreateCollectionEntity(
                imgaeUrl: imageUrl,
                title: titleText,
                description: descriptionText,
                isPublic: isPublic,
                contentList: contentList
            )
        } else {
            createEntity = nil
        }

        isDoneEnabled.send(canCreate)
    }
}
