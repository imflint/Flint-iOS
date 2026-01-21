//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation
import Security

import Domain

public enum TokenType: String, CaseIterable {
    case accessToken
    case refreshToken
}

public protocol TokenStorage {
    func save(_ token: String, type: TokenType)
    func load(type: TokenType) -> String?
    func delete(type: TokenType)
    func clearAll()
}


public final class DefaultTokenStorage: TokenStorage {
    
    public init() {
        
    }
    
    public func save(_ token: String, type: TokenType) {
        guard let tokenData = token.data(using: .utf8) else {
            Log.e("Token Data Encoding Error")
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // 일반 데이터 저장
            kSecAttrAccount as String: type.rawValue,             // 계정 이름
            kSecValueData as String: tokenData,             // 실제 토큰 데이터
        ]
        
        // 기존 항목 삭제 후 새로운 항목 저장
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            Log.d("Keychain \(type.rawValue) 저장 완료")
        }
    }
    
    public func load(type: TokenType) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.rawValue,
            kSecReturnData as String: true,                 // 데이터를 반환하도록 설정
            kSecMatchLimit as String: kSecMatchLimitOne     // 하나의 결과만 반환
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            Log.e("Keychain \(type.rawValue) load failed. \(status)")
            return nil
        }
        guard let data = item as? Data else {
            Log.e("Keychain \(type.rawValue) data invalid")
            return nil
        }
        guard let token = String(data: data, encoding: .utf8) else {
            Log.e("Keychain \(type.rawValue) string encoding failed.")
            return nil
        }
        return token
    }
    
    public func delete(type: TokenType) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.rawValue,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            Log.e("Keychain \(type.rawValue) delete failed. \(status)")
            return
        }
    }
    
    public func clearAll() {
        TokenType.allCases.forEach { tokenType in
            delete(type: tokenType)
        }
    }
}

public final class TestTokenStorage: TokenStorage {
    public func save(_ token: String, type: TokenType) {
        return
    }
    
    public func load(type: TokenType) -> String? {
        return NetworkConfig.testToken
    }
    
    public func delete(type: TokenType) {
        return
    }
    
    public func clearAll() {
        return
    }
}
