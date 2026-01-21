//
//  BaseResponseDTO.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

import Domain

public struct BaseResponse<T: Codable>: Codable {
    
    /// error
    public let title: String?
    public let detail: String?
    public let instance: String?
    public let errorCode: String?
    public let additionalInfo: [String: String]?
    
    public let status: Int
    public let message: String
    public let data: T?
}

/// data가 없는 API 통신에서 사용할 BlankData 구조체
public struct BlankData: Codable {
}

extension BaseResponse {
    public var serverError: ServerError {
        return ServerError(
            title: title ?? "",
            detail: detail ?? "",
            instance: instance ?? "",
            errorCode: errorCode ?? "",
            additionalInfo: additionalInfo ?? [:],
            status: status,
            message: message
        )
    }
}
