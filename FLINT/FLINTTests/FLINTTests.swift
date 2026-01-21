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
@testable import FLINT

final class FLINTTests: XCTestCase {
    
    var tokenStorage: TokenStorage!
    var diContainer: DIContainer!
    
    var createCollectionUseCase: CreateCollectionUseCase!
    
    override func setUp() {
        super.setUp()
        
        tokenStorage = TestTokenStorage()
        diContainer = DIContainer()
        createCollectionUseCase = diContainer.makeCreateCollectionUseCase()
    }
    
    override func tearDown() {
        tokenStorage = nil
        diContainer = nil
        createCollectionUseCase = nil
        
        super.tearDown()
    }
    
    func testCreateCollectionUseCase() throws {
        let expectation = XCTestExpectation(description: "비동기 Test")
        var receivedValue: Bool?
        
        let cancellable = createCollectionUseCase.createCollection(
            CreateCollectionEntity(
                imgaeUrl: "https://d1al7qj7ydfbpt.cloudfront.net/artists/jyp/galleries/1763966579709-5fa1192d.jpg",
                title: "진영오빠 사랑해",
                description: "진영이 영원해",
                isPublic: true,
                contentList: [
                    .init(
                        contentId: 800388257884431200,
                        isSpoiler: false,
                        reason: "ㅇㅇ"
                    )
                ]
            )
        ).sink(receiveCompletion: { result in
            switch result {
            case .finished:
                Log.d("finished")
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }, receiveValue: { _ in
            XCTAssert(true)
        })
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(receivedValue, false)
        
        cancellable.cancel()
    }
    
    func testFetchRecommendedCollections_success() {
        let expectation = XCTestExpectation(description: "fetchRecommendedCollections completes")

        var receivedEntity: HomeRecommendedCollectionsEntity?
        var receivedError: Error?

        let homeUseCase: HomeUseCase = diContainer.makeHomeUseCase()

        let cancellable = homeUseCase.fetchRecommendedCollections()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { entity in
                    receivedEntity = entity
                }
            )

        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()

        if let receivedError {
            XCTFail("fetchRecommendedCollections failed with error: \(receivedError)")
            return
        }

        XCTAssertNotNil(receivedEntity)
        XCTAssertFalse(receivedEntity?.collections.isEmpty ?? true)
    }
}
