//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.20.
//

import Foundation

import Domain

public enum NetworkConfig {
    
    public static let tempToken: String = {
        guard let tempToken = Bundle.main.object(forInfoDictionaryKey: "temp_token") as? String else { fatalError("temp_token not found.") }
        Log.d(tempToken)
        return tempToken
    }()
    
    public static let kakaoAppKey: String = {
        guard let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "kakao_app_key") as? String else { fatalError("kakao_app_key not found.") }
        Log.d(kakaoAppKey)
        return kakaoAppKey
    }()
    
    public static let baseURL: URL = {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "base_url") as? String else { fatalError("base_url not found.") }
        Log.d(baseURLString)
        guard let baseURL = URL(string: "https://\(baseURLString)") else { fatalError("Invalid BaseURL") }
        return baseURL
    }()
    
    public static let testToken: String = {
        guard let testToken = Bundle.main.object(forInfoDictionaryKey: "test_token") as? String else { fatalError("test_token not found.") }
        Log.d(testToken)
        return testToken
    }()
}
