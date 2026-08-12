//
//  CreateCollectionViewModel.swift
//  Presentation
//
//  Created by 소은 on 2026.01.22.
//

import Combine
import Foundation

import Domain
import UIKit

public enum CreateCollectionMode: Equatable {
    case create
    case edit(collectionId: Int64)
}

public protocol CreateCollectionViewModelInput {
    func updateTitle(_ title: String)
    func updateDescription(_ description: String)
    func updateVisibility(_ isPublic: Bool)
    func updateContentList(_ list: [CreateCollectionEntity.CreateCollectionContents])
    func updateImageUrl(_ imageUrl: String)
    func createCollection()
    func uploadImages(_ images: [UIImage]) -> AnyPublisher<[String], Error>
}

public protocol CreateCollectionViewModelOutput {
    var isDoneEnabled: CurrentValueSubject<Bool, Never> { get }
    var createSuccess: PassthroughSubject<Int64, Never> { get }
    var createFailure: PassthroughSubject<Error, Never> { get }
}

public typealias CreateCollectionViewModel = CreateCollectionViewModelInput & CreateCollectionViewModelOutput

public final class DefaultCreateCollectionViewModel: CreateCollectionViewModel {

    private let mode: CreateCollectionMode
    private let createCollectionUseCase: CreateCollectionUseCase
    private let updateCollectionUseCase: UpdateCollectionUseCase
    private let uploadImageUseCase: UploadCollectionImageUseCase

    public var isDoneEnabled: CurrentValueSubject<Bool, Never> = .init(false)
    public var createSuccess: PassthroughSubject<Int64, Never> = .init()
    public var createFailure: PassthroughSubject<Error, Never> = .init()

    // MARK: - State
    private var imageUrl: String = ""
    private var titleText: String = ""
    private var descriptionText: String = ""
    private var isPublic: Bool? = nil
    
    private var contentList: [CreateCollectionEntity.CreateCollectionContents] = []

    private var createEntity: CreateCollectionEntity?
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    public init(
        mode: CreateCollectionMode = .create,
        createCollectionUseCase: CreateCollectionUseCase,
        updateCollectionUseCase: UpdateCollectionUseCase,
        uploadImageUseCase: UploadCollectionImageUseCase
    ) {
        self.mode = mode
        self.createCollectionUseCase = createCollectionUseCase
        self.updateCollectionUseCase = updateCollectionUseCase
        self.uploadImageUseCase = uploadImageUseCase
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

    public func updateImageUrl(_ imageUrl: String) {
        self.imageUrl = imageUrl
        evaluateDoneEnabled()
    }

    public func uploadImages(_ images: [UIImage]) -> AnyPublisher<[String], Error> {
        let publishers = images.map { uploadImageUseCase($0) }
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }

    public func createCollection() {
        guard isDoneEnabled.value else { return }
        guard let entity = createEntity else { return }

        switch mode {
        case .create:
            submitCreate(entity: entity)
        case .edit(let collectionId):
            submitUpdate(collectionId: collectionId, entity: entity)
        }
    }

    private func submitCreate(entity: CreateCollectionEntity) {
        createCollectionUseCase(collectionInfo: entity)
            .manageThread()
            .map { collectionId in Result<Int64, Error>.success(collectionId) }
            .catch { Just(Result<Int64, Error>.failure($0)) }
            .sinkHandledCompletion { [weak self] result in
                switch result {
                case .success(let collectionId):
                    self?.createSuccess.send(collectionId)
                case .failure(let error):
                    self?.createFailure.send(error)
                }
            }
            .store(in: &cancellables)
    }

    private func submitUpdate(collectionId: Int64, entity: CreateCollectionEntity) {
        updateCollectionUseCase(collectionId: collectionId, collectionInfo: entity)
            .manageThread()
            .map { Result<Int64, Error>.success(collectionId) }
            .catch { Just(Result<Int64, Error>.failure($0)) }
            .sinkHandledCompletion { [weak self] result in
                switch result {
                case .success(let collectionId):
                    self?.createSuccess.send(collectionId)
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
        let visibilityValid = isPublic != nil
        let reasonValid = contentList.count >= 2 && contentList.allSatisfy {
            !$0.reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        let descriptionValid = true
        let imageValid = true

        let canCreate = titleValid && countValid && visibilityValid && reasonValid && descriptionValid && imageValid

        if canCreate {
            createEntity = CreateCollectionEntity(
                imgaeUrl: imageUrl,
                title: titleText,
                description: descriptionText,
                isPublic: isPublic ?? false,
                contentList: contentList
            )
        } else {
            createEntity = nil
        }

        isDoneEnabled.send(canCreate)
    }
}
