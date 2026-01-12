//
//  ExampleDTO.swift
//  FLINT
//
//  Created by 진소은 on 1/9/26.
//

import Foundation

struct ExampleDTO: Decodable {
    let code: Int
    let data: DataDTO
    let message: String

    struct DataDTO: Decodable {
        let title: String
        let team: String
    }
}
