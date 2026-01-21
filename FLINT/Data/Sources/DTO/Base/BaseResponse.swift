//
//  BaseResponseDTO.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

public struct BaseResponse<T: Codable>: Codable {
    public let status: Int
    public let message: String
    public let data: T?
}

/// data가 없는 API 통신에서 사용할 BlankData 구조체
public struct BlankData: Codable {
}
