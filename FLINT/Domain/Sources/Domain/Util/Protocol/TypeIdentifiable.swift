//
//  Identifiable.swift
//  Domain
//
//  Created by 김호성 on 2025.11.12.
//

import Foundation

public protocol TypeIdentifiable {
    static var typeIdentifier: String { get }
}

extension TypeIdentifiable {
    public static var typeIdentifier : String {
        return String(describing: self)
    }
}
