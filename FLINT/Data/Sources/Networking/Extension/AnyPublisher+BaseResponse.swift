//
//  AnyPublisher+BaseResponse.swift
//  Data
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation

import CombineMoya
import Moya

import Domain

import DTO

public extension AnyPublisher where Output == Response, Failure == MoyaError {
    func mapBaseResponseData<D: Codable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true, filename: String = #file, line: Int = #line, funcName: String = #function) -> AnyPublisher<D, Error> {
        return map(BaseResponse<D>.self)
            .tryMap({ baseResponse in
                Log.d(baseResponse, filename: filename, line: line, funcName: funcName)
                guard (200..<300).contains(baseResponse.status) else {
                    throw NetworkError.httpStatusCode(baseResponse.serverError)
                }
                guard let data = baseResponse.data else {
                    throw NetworkError.noData
                }
                return data
            })
            .eraseToAnyPublisher()
    }
}
