//
//  KeyChainTests.swift
//  FLINTTests
//
//  Created by 김호성 on 2026.01.27.
//

import XCTest
@testable import Data
@testable import FLINT

final class KeyChainTests: XCTestCase {
    
    private var tokenStorage: TokenStorage!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        tokenStorage = DefaultTokenStorage()
        tokenStorage.clearAll()
//        tokenStorage = TestTokenStorage()
    }

    override func tearDownWithError() throws {
        tokenStorage.clearAll()
        tokenStorage = nil
        
        try super.tearDownWithError()
    }
    
    func testSaveAndLoadAccessToken() throws {
        let token = "access_token_00"
        
        tokenStorage.save(token, type: .accessToken)
        let loadedToken = tokenStorage.load(type: .accessToken)
        
        XCTAssertEqual(token, loadedToken)
    }
    func testSaveAndLoadTempToken() throws {
        let token = "temp_token_00"
        
        tokenStorage.save(token, type: .tempToken)
        let loadedToken = tokenStorage.load(type: .tempToken)
        
        XCTAssertEqual(token, loadedToken)
    }
    func testSaveAndLoadRefreshToken() throws {
        let token = "refresh_token_00"
        
        tokenStorage.save(token, type: .refreshToken)
        let loadedToken = tokenStorage.load(type: .refreshToken)
        
        XCTAssertEqual(token, loadedToken)
    }
    
    func testLoadWithoutSaving() {
        let loadedToken = tokenStorage.load(type: .accessToken)
        
        XCTAssertNil(loadedToken)
    }
    
    func testDelete() {
        let token = "access_token_01"
        tokenStorage.save(token, type: .accessToken)
        
        tokenStorage.delete(type: .accessToken)
        
        let loadedToken = tokenStorage.load(type: .accessToken)
        XCTAssertNil(loadedToken)
    }
    
    func testSaveOverridesExistingToken() {
        let oldToken = "access_token_02"
        let newToken = "access_token_03"
        
        tokenStorage.save(oldToken, type: .accessToken)
        tokenStorage.save(newToken, type: .accessToken)
        
        let loadedToken = tokenStorage.load(type: .accessToken)
        XCTAssertEqual(newToken, loadedToken)
    }
    
    func testClearAll() {
        tokenStorage.save("access_token_04", type: .accessToken)
        tokenStorage.save("refresh_token_01", type: .refreshToken)
        tokenStorage.save("temp_token_01", type: .tempToken)
        
        tokenStorage.clearAll()
        
        XCTAssertNil(tokenStorage.load(type: .accessToken))
        XCTAssertNil(tokenStorage.load(type: .refreshToken))
        XCTAssertNil(tokenStorage.load(type: .tempToken))
    }
}
