//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.21.
//

import Foundation
import Security

public enum TokenType: String {
    case accessToken
    case refreshToken
}

public enum TokenError: Error, LocalizedError {
    
}

public protocol TokenStorage {
    func save(_ token: String, type: TokenType) throws
    func load(type: TokenType) -> String?
    func delete(type: TokenType) throws
    func clearAll() throws
}


public final class DefaultTokenStorage: TokenStorage {
    public func save(_ token: String, type: TokenType) throws {
        guard let tokenData = token.data(using: .utf8) else {
            
        }
        
        // Access Control 설정 (Face ID 또는 기기 잠금 해제 후 접근 가능)
        let accessControl = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlocked,
            .userPresence,   // 사용자 인증 (Face ID, Touch ID 또는 기기 암호)
            nil
        )
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // 일반 데이터 저장
            kSecAttrAccount as String: account,             // 계정 이름
            kSecAttrService as String: service,             // 서비스 이름
            kSecValueData as String: tokenData,             // 실제 토큰 데이터
            kSecAttrAccessControl as String: accessControl! // 접근 제어 추가
        ]
        
        // 기존 항목 삭제 후 새로운 항목 저장
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    public func load(type: TokenType) -> String? {
        <#code#>
    }
    
    public func delete(type: TokenType) throws {
        <#code#>
    }
    
    public func clearAll() throws {
        <#code#>
    }
    
    
    public init() {
        
    }
    
    
    public func loadToken(account: String, service: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: true,                 // 데이터를 반환하도록 설정
            kSecMatchLimit as String: kSecMatchLimitOne     // 하나의 결과만 반환
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else { return nil }
        
        if let data = item as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    // 토큰 삭제 함수
    @discardableResult
    public func deleteToken(account: String, service: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
}
