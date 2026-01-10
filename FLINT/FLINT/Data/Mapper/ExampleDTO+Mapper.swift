//
//  ExampleDTO+Mapper.swift
//  FLINT
//
//  Created by 진소은 on 1/9/26.
//

import Foundation

enum ExampleMappingError: Error, LocalizedError {
    case server(code: Int, message: String)

    var errorDescription: String? {
        switch self {
        case let .server(code, message):
            return "Server error (code: \(code)): \(message)"
        }
    }
}

protocol ExampleMapper {
    func toDomain(_ dto: ExampleDTO) throws -> ExampleEntity
}

struct ExampleMapperImpl: ExampleMapper {
    func toDomain(_ dto: ExampleDTO) throws -> ExampleEntity {
        guard dto.code == 200 else {
            throw ExampleMappingError.server(code: dto.code, message: dto.message)
        }
        return ExampleEntity(title: dto.data.title, team: dto.data.team)
    }
}
