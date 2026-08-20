//
//  SavedFilmListViewModel.swift
//  Presentation
//
//  Created by 진소은 on 8/20/26.
//

import Combine
import Foundation

import Domain

public final class SavedFilmListViewModel {

    // MARK: - Constant
    /// 저장 취소 제한 최소 개수 — 이 값 이하일 때 저장 취소 시도하면 안내 모달 노출
    public static let minimumBookmarkCount = 5
    /// 한 페이지 사이즈 — 서버 최대치 50
    private static let pageSize: Int32 = 50

    // MARK: - Output
    @Published public private(set) var displayItems: [ContentInfoEntity] = []
    /// 서버 기준 총 저장 개수 (페이지네이션과 무관하게 전체 수)
    @Published public private(set) var totalCount: Int = 0

    /// 저장 취소가 최소 개수 제한에 걸린 경우 발신 (VC 에서 안내 모달 표시)
    public let bookmarkRemovalBlocked = PassthroughSubject<Void, Never>()

    // MARK: - Dependency
    private let fetchBookmarkedContentsPageUseCase: FetchBookmarkedContentsPageUseCase
    private let fetchBookmarkedContentCountUseCase: FetchBookmarkedContentCountUseCase
    private let toggleContentBookmarkUseCase: ToggleContentBookmarkUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State
    private var allItems: [ContentInfoEntity] = []
    private var query: String = ""
    private var nextCursor: String?
    private var isLoading: Bool = false
    private var hasReachedEnd: Bool = false

    public init(
        fetchBookmarkedContentsPageUseCase: FetchBookmarkedContentsPageUseCase,
        fetchBookmarkedContentCountUseCase: FetchBookmarkedContentCountUseCase,
        toggleContentBookmarkUseCase: ToggleContentBookmarkUseCase
    ) {
        self.fetchBookmarkedContentsPageUseCase = fetchBookmarkedContentsPageUseCase
        self.fetchBookmarkedContentCountUseCase = fetchBookmarkedContentCountUseCase
        self.toggleContentBookmarkUseCase = toggleContentBookmarkUseCase
    }

    // MARK: - Load

    public func load() {
        allItems = []
        nextCursor = nil
        hasReachedEnd = false
        applyFilter()
        loadNextPage()
        refreshTotalCount()
    }

    public func loadNextPage() {
        guard !isLoading, !hasReachedEnd else { return }
        isLoading = true

        fetchBookmarkedContentsPageUseCase(cursor: nextCursor, size: Self.pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    print("fetchSavedContentsPage failed:", error)
                }
            } receiveValue: { [weak self] page in
                guard let self else { return }
                self.allItems.append(contentsOf: page.items)
                self.nextCursor = page.nextCursor
                self.hasReachedEnd = (page.nextCursor == nil || page.items.isEmpty)
                self.applyFilter()
            }
            .store(in: &cancellables)
    }

    private func refreshTotalCount() {
        fetchBookmarkedContentCountUseCase()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchBookmarkedContentCount failed:", error)
                }
            } receiveValue: { [weak self] count in
                self?.totalCount = count
            }
            .store(in: &cancellables)
    }

    public func updateQuery(_ query: String) {
        self.query = query
        applyFilter()
    }

    public func toggleBookmark(contentIdString: String) {
        guard let contentId = Int64(contentIdString) else { return }

        // 이 화면의 아이템은 모두 저장 상태 → 항상 '저장 취소'.
        // 서버 총 개수 기준으로 최소치 판정 (페이지네이션과 무관)
        if totalCount <= Self.minimumBookmarkCount {
            bookmarkRemovalBlocked.send(())
            return
        }

        // 낙관적 갱신: 리스트에서 즉시 제거 + 카운트 감소
        allItems.removeAll { $0.id == contentIdString }
        totalCount = max(0, totalCount - 1)
        applyFilter()

        toggleContentBookmarkUseCase(contentId: contentId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("toggleContentBookmark failed:", error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    private func applyFilter() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            displayItems = allItems
        } else {
            displayItems = allItems.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
        }
    }
}
