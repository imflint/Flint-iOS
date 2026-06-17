//
//  Codable+Ext.swift
//  Domain
//
//  Created by 김호성 on 2025.09.25.
//

import Foundation

extension Encodable {
    public func encode(fileName: String = #file, line: Int = #line, funcName: String = #function) -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            Log.e(error.localizedDescription, fileName: fileName, line: line, funcName: funcName)
            return nil
        }
    }
}
