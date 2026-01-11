//
//  BaseResponseDTO.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

public struct BaseResponseDTO<T: Decodable>: Decodable {
    public let code: Int
    public let data: T
    public let message: String
}
