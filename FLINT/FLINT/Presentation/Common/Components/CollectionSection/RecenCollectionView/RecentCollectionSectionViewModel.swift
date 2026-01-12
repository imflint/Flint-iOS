//
//  RecentCollectionSectionViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import Combine

final class RecentCollectionSectionViewModel {

    // MARK: - Input

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let moreTap: AnyPublisher<Void, Never>
        let itemSelect: AnyPublisher<UUID, Never>
    }

    // MARK: - Output

    struct Output {
        let items: AnyPublisher<[RecentCollectionItemViewData], Never>
        let moreTap: AnyPublisher<Void, Never>
        let itemSelect: AnyPublisher<UUID, Never>
    }

    // MARK: - Dependencies

    private let useCase: RecentCollectionUseCaseProtocol

    // MARK: - State

    private let itemsSubject = CurrentValueSubject<[RecentCollectionItemViewData], Never>([])
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(useCase: RecentCollectionUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                self?.fetch()
            }
            .store(in: &cancellables)

        return Output(
            items: itemsSubject.eraseToAnyPublisher(),
            moreTap: input.moreTap,
            itemSelect: input.itemSelect
        )
    }

    // MARK: - Private

    private func fetch() {
        useCase.fetchRecentCollections()
            .map { entities in
                entities.map {
                    RecentCollectionItemViewData(
                        id: $0.id,
                        image: $0.imageName.flatMap { UIImage(named: $0) },
                        title: $0.title,
                        userName: $0.userName,
                        profileImage: $0.profileImageName.flatMap { UIImage(named: $0) }
                    )
                }
            }
            .replaceError(with: [])
            .sink { [weak self] viewData in
                self?.itemsSubject.send(viewData)
            }
            .store(in: &cancellables)
    }
}
