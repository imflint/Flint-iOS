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
    var savedCount: CurrentValueSubject<Int, Never> { get }
}

public typealias AddContentSelectViewModel = AddContentSelectViewModelInput & AddContentSelectViewModelOutput

public final class DefaultAddContentSelectViewModel: AddContentSelectViewModel {

    // MARK: - Dependency

    private let fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase
    private let fetchBookmarkedContentCountUseCase: FetchBookmarkedContentCountUseCase
    private let searchContentsUseCase: SearchContentsUseCase

    // MARK: - Output

    public var results: CurrentValueSubject<[ContentEntity], Never> = .init([])
    public var isSearching: CurrentValueSubject<Bool, Never> = .init(false)
    /// 검색어 없을 때(기본 상태) 보여줄 "저장한 작품" 총 개수
    public var savedCount: CurrentValueSubject<Int, Never> = .init(0)

    // MARK: - Private

    private let keywordSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    private var fetchCancellable: AnyCancellable?
    private var countCancellable: AnyCancellable?

    // MARK: - Init

    public init(
        fetchBookmarkedContentsUseCase: FetchBookmarkedContentsUseCase,
        fetchBookmarkedContentCountUseCase: FetchBookmarkedContentCountUseCase,
        searchContentsUseCase: SearchContentsUseCase
    ) {
        self.fetchBookmarkedContentsUseCase = fetchBookmarkedContentsUseCase
        self.fetchBookmarkedContentCountUseCase = fetchBookmarkedContentCountUseCase
        self.searchContentsUseCase = searchContentsUseCase
        bind()
    }

    // MARK: - Input

    public func updateKeyword(keyword: String) {
        keywordSubject.send(keyword)
    }

    public func fetchContents() {
        searchCancellable = nil
        isSearching.send(false)

        fetchCancellable = fetchBookmarkedContentsUseCase(for: .me)
            .manageThread()
            .sinkHandledCompletion { [weak self] items in
                guard let self else { return }
                self.results.send(items.map(self.toContentEntity))
            }

        countCancellable = fetchBookmarkedContentCountUseCase()
            .manageThread()
            .sinkHandledCompletion { [weak self] count in
                self?.savedCount.send(count)
            }
    }

    // MARK: - Private

    private func toContentEntity(_ info: ContentInfoEntity) -> ContentEntity {
        ContentEntity(
            id: info.id,
            title: info.title,
            author: "",
            posterUrl: URL(string: info.imageUrl),
            year: info.year
        )
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

        fetchCancellable = nil
        countCancellable = nil
        searchCancellable = nil
        isSearching.send(true)

        searchCancellable = searchContentsUseCase(keyword: keyword, genre: [], mediaType: nil, cursor: nil)
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.results.send(contents.data)
            }
    }
}
