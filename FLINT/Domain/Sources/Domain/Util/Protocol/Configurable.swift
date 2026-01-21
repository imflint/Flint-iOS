//
//  Configurable.swift
//  Domain
//
//  Created by 김호성 on 2025.11.18.
//

import Foundation

public protocol Configurable {
    
}

extension Configurable where Self: AnyObject {
    @inlinable public func configured(_ block: (_ target: Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: Configurable { }
