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
    func fetchContents()
}

public protocol AddContentSelectViewModelOutput {
    var results: CurrentValueSubject<[ContentEntity], Never> { get }
    var isSearching: CurrentValueSubject<Bool, Never> { get }
}

public typealias AddContentSelectViewModel = AddContentSelectViewModelInput & AddContentSelectViewModelOutput

public final class DefaultAddContentSelectViewModel: AddContentSelectViewModel {

    // MARK: - Dependency

    private let contentsUseCase: ContentsUseCase
    private let searchContentsUseCase: SearchContentsUseCase

    // MARK: - Output

    public var results: CurrentValueSubject<[ContentEntity], Never> = .init([])
    public var isSearching: CurrentValueSubject<Bool, Never> = .init(false)

    // MARK: - Private

    private let keywordSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(
        contentsUseCase: ContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase
    ) {
        self.contentsUseCase = contentsUseCase
        self.searchContentsUseCase = searchContentsUseCase
        bind()
    }

    // MARK: - Input

    public func updateKeyword(keyword: String) {
        keywordSubject.send(keyword)
    }

    public func fetchContents() {
        isSearching.send(false)

        contentsUseCase.fetchContents()
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.results.send(contents)
            }
            .store(in: &cancellables)
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
        if keyword.isEmpty {
            fetchContents()
            return
        }

        isSearching.send(true)

        searchContentsUseCase.searchContents(keyword)
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.results.send(contents)
            }
            .store(in: &cancellables)
    }
}
