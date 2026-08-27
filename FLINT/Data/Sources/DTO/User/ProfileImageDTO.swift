//
//  File.swift
//  Data
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Foundation

public struct ProfileImageDTO: Codable {
    let profileImage: String
    
    package init(profileImage: String) {
        self.profileImage = profileImage
    }
}
