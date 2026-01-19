//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import Moya
import CombineMoya

import Domain

import DTO

public extension AnyPublisher where Output == Response, Failure == MoyaError {
    func extractData<D: Codable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D, NetworkError> {
        return map(BaseResponse<D>.self)
            .tryMap({ baseResponse in
                guard (200..<300).contains(baseResponse.status) else {
                    throw NetworkError.httpStatusCode(
                        code: baseResponse.status,
                        message: baseResponse.message
                    )
                }
                guard let data = baseResponse.data else {
                    throw NetworkError.noData
                }
                return data
            })
            .mapError({ error in
                Log.e(error.localizedDescription
                )
                return error as? NetworkError ?? .unknown
            })
            .eraseToAnyPublisher()
    }
}
