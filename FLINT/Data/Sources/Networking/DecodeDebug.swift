//
//  DecodeDebug.swift
//  Data
//
//  Created by 소은 on 1/22/26.
//

import Foundation

enum DecodeDebug {

    static func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            printDecodingError(error, data: data)
            throw error
        } catch {
            print("❌ Decode Error:", error)
            print("📦 Raw:", String(data: data, encoding: .utf8) ?? "nil")
            throw error
        }
    }

    private static func printDecodingError(_ error: DecodingError, data: Data) {
        let raw = String(data: data, encoding: .utf8) ?? "nil"

        switch error {
        case .keyNotFound(let key, let context):
            print("""
            ❌ DecodingError.keyNotFound
            - key: \(key.stringValue)
            - codingPath: \(codingPathString(context.codingPath))
            - debug: \(context.debugDescription)
            📦 Raw: \(raw)
            """)

        case .typeMismatch(let type, let context):
            print("""
            ❌ DecodingError.typeMismatch
            - type: \(type)
            - codingPath: \(codingPathString(context.codingPath))
            - debug: \(context.debugDescription)
            📦 Raw: \(raw)
            """)

        case .valueNotFound(let type, let context):
            print("""
            ❌ DecodingError.valueNotFound
            - type: \(type)
            - codingPath: \(codingPathString(context.codingPath))
            - debug: \(context.debugDescription)
            📦 Raw: \(raw)
            """)

        case .dataCorrupted(let context):
            print("""
            ❌ DecodingError.dataCorrupted
            - codingPath: \(codingPathString(context.codingPath))
            - debug: \(context.debugDescription)
            📦 Raw: \(raw)
            """)

        @unknown default:
            print("❌ DecodingError.unknown")
            print("📦 Raw:", raw)
        }
    }

    private static func codingPathString(_ path: [CodingKey]) -> String {
        path.map { $0.stringValue }.joined(separator: " > ")
    }
}
