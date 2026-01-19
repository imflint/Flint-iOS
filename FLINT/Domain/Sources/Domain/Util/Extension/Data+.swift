//
//  Data+Ext.swift
//  Domain
//
//  Created by 김호성 on 2025.09.25.
//

import Foundation

extension Data {
    public func decode<T: Decodable>(type: T.Type, filename: String = #file, line: Int = #line, funcName: String = #function) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            Log.e(error.localizedDescription, filename: filename, line: line, funcName: funcName)
            return nil
        }
    }
}
