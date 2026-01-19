//
//  FLINTTests.swift
//  FLINTTests
//
//  Created by 김호성 on 2026.01.19.
//

import XCTest
import Combine
@testable import Data

final class FLINTTests: XCTestCase {
    
    private var userService: UserService!
    
    override func setUp() {
        super.setUp()
        
        userService = DefaultUserService()
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
        
        let cancellable = userService.checkNickname(nickname: "코코아")
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { nicknameCheckDTO in
                receivedValue = nicknameCheckDTO.available
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedValue, false)
        
        cancellable.cancel()
    }
}
