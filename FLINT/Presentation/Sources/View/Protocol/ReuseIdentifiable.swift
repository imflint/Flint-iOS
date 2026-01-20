//
//  ReuseIdentifiable.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import Foundation

public protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    public static var reuseIdentifier: String { String(describing: self) }
}
