//
//  AddContentSelectViewModel.swift
//  Presentation
//
//  Created by 소은 on 1/22/26.
//

import Combine
import Foundation

import Domain

public protocol AddContentSelectViewModelInput {
    func updateKeyword(keyword: String)
}

public protocol AddContentSelectViewModelOutput {
    var results: CurrentValueSubject<[SearchContentsEntity.SearchContent], Never> { get }

    var isSearching: CurrentValueSubject<Bool, Never> { get }
}

public typealias AddContentSelectViewModel = AddContentSelectViewModelInput & AddContentSelectViewModelOutput

public final class DefaultAddContentSelectViewModel: AddContentSelectViewModel {

    private let useCase: SearchContentsUseCase

    public var results: CurrentValueSubject<[SearchContentsEntity.SearchContent], Never> = .init([])
    public var isSearching: CurrentValueSubject<Bool, Never> = .init(false)

    private let keywordSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()

    public init(useCase: SearchContentsUseCase) {
        self.useCase = useCase
        bind()
    }

    public func updateKeyword(keyword: String) {
        keywordSubject.send(keyword)
    }
}

public extension DefaultAddContentSelectViewModel {

    func bind() {
        keywordSubject
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] keyword in
                self?.searchIfNeeded(keyword: keyword)
            }
            .store(in: &cancellables)
    }

    func searchIfNeeded(keyword: String) {
        guard !keyword.isEmpty else {
            isSearching.send(false)
            results.send([])
            return
        }

        isSearching.send(true)

        useCase.searchContents(keyword: keyword)
            .manageThread()
            .map(\.contents)
            .sinkHandledCompletion { [weak self] contents in
                self?.results.send(contents)
            }
            .store(in: &cancellables)
    }
}
