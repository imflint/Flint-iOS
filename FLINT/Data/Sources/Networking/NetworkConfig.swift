//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.20.
//

import Foundation

import Domain

enum NetworkConfig {
    static let baseURL: URL = {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }()
}
