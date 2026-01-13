//
//  ExampleDTO+Mapper.swift
//  FLINT
//
//  Created by 진소은 on 1/9/26.
//

import Foundation

extension ExampleDTO {
    func toDomain() throws -> ExampleEntity {
        guard code == 200 else {
            throw MappingError.server(code: code, message: message)
        }
        return ExampleEntity(title: data.title, team: data.team)
    }
}
