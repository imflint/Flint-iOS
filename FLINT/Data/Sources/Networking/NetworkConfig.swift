//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.20.
//

import Foundation

import Domain

enum NetworkConfig {
    static let resource: [String: String] = {
        guard let file = Bundle.module.path(forResource: "Secret", ofType: "plist") else { fatalError("Secret.plist not found.") }
        guard let resource = NSDictionary(contentsOfFile: file) as? [String: String] else { fatalError("Secret.plist not found.") }
        return resource
    }()
    
    static let baseURL: URL = {
        guard let baseURLString = resource["base_url"] else { fatalError("base_url not found.") }
        guard let baseURL = URL(string: baseURLString) else { fatalError("Invalid BaseURL") }
        return baseURL
    }()
    
    static let testToken: String = {
        guard let testToken = resource["test_token"] else { fatalError("test_token not found.") }
        return testToken
    }()
}
