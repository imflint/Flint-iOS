//
//  FLINTTests.swift
//  FLINTTests
//
//  Created by 김호성 on 2026.01.19.
//

import XCTest
import Combine
@testable import Data
@testable import Domain

final class FLINTTests: XCTestCase {
    
    private var userService: UserService!
    private var searchContentsService: SearchService!
    private var collectionService: CollectionService!
    
    override func setUp() {
        super.setUp()
        
        userService = DefaultUserService()
        searchContentsService = DefaultSearchService()
        collectionService = DefaultCollectionService()
    }
    
    override func tearDown() {
        userService = nil
        
        super.tearDown()
    }

    func testCheckNickname() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let expectation = XCTestExpectation(description: "비동기 Test")
        var receivedValue: Bool?
        
        let cancellable = userService.checkNickname("코코아")
            .sink(receiveCompletion: { result in
                Log.d(result)
            }, receiveValue: { dto in
                receivedValue = dto.available
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(receivedValue, false)
        
        cancellable.cancel()
    }
    
    func testSearchService() throws {
        let expectation = XCTestExpectation(description: "비동기 Test")
        var receivedValue: [SearchContentsDTO.ContentDTO]?
        
        let cancellable = searchContentsService.searchContents("주토피아")
            .sink(receiveCompletion: { result in
                Log.d(result)
            }, receiveValue: { dto in
                receivedValue = dto.contents ?? []
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(receivedValue?.isEmpty, false)
        
        cancellable.cancel()
    }
    
    func testCollectionService() throws {
        let expectation = XCTestExpectation(description: "비동기 Test")
        let request = CreateCollectionEntity(imgaeUrl: "collection/image/abc123.jpg", title: "주말에 보기 좋은 영화", description: "주말에 편하게 볼 수 있는 영화들을 모았습니다.", isPublic: true, contentList: [])
        
        let cancellable = collectionService.createCollection(request)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    return
                case .failure(let failure):
                    XCTFail(failure.localizedDescription)
                }
                Log.d(result)
            }, receiveValue: { _ in
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssert(true)
        
        cancellable.cancel()
    }
    
    func testHomeRepository_fetchRecommendedCollections() throws {
        let expectation = XCTestExpectation(description: "비동기 Test")
        let homeRepository = DefaultHomeRepository(homeService: DefaultHomeService())
        var receivedValue: [HomeRecommendedCollectionsEntity.HomeRecommendedCollectionEntity]?
        var receivedError: NetworkError?

        let cancellable = homeRepository.fetchRecommendedCollections()
            .sink(receiveCompletion: { result in
                if case .failure(let error) = result {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { entity in
                receivedValue = entity.collections
            })

        wait(for: [expectation], timeout: 3.0)

        if let error = receivedError {
            XCTFail("Home API failed: \(error)")
            cancellable.cancel()
            return
        }

        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.isEmpty, false)

        cancellable.cancel()
    }

    func testFetchOTTPlatformsRepository() throws {
        let expectation = XCTestExpectation(description: "비동기 Test")

        let repository = DefaultContentRepository(contentService: DefaultContentService())
        var receivedValue: [FetchOTTPlatformsEntity.OTTPlatformEntity]?
        var receivedError: NetworkError?

        let cancellable = repository.fetchOTTPlatforms(1073741824) // ⚠️ 실제 존재하는 contentId로 변경
            .sink(receiveCompletion: { result in
                if case .failure(let error) = result {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { entity in
                receivedValue = entity.ottPlatforms
            })

        wait(for: [expectation], timeout: 3.0)

        if let error = receivedError {
            XCTFail("fetchOTTPlatforms failed: \(error)")
            cancellable.cancel()
            return
        }

        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.isEmpty, false)

        cancellable.cancel()
    }
    func testToggleContentBookmark_Fails_WithoutToken() throws {
        let expectation = XCTestExpectation(description: "Auth Required Test")

        let repository = DefaultBookmarkRepository(
            bookmarkService: DefaultBookmarkService()
        )

        var didFail = false

        let cancellable = repository.toggleContentBookmark(1)
            .sink(receiveCompletion: { result in
                if case .failure = result {
                    didFail = true
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })

        wait(for: [expectation], timeout: 3.0)
        XCTAssertTrue(didFail)

        cancellable.cancel()
    }
}
