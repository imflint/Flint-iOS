//
//  File.swift
//  Data
//
//  Created by Hosung.Kim on 2026.08.23.
//

import Foundation

package struct RefreshRequestDTO: Codable {
    let refreshToken: String
    
    package init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
