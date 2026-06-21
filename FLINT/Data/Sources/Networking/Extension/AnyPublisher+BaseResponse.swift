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

extension AnyPublisher where Output == Response, Failure == MoyaError {
    public func mapBaseResponseData<D: Codable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true, fileName: String = #file, line: Int = #line, funcName: String = #function) -> AnyPublisher<D, Error> {
        return map(BaseResponse<D>.self)
            .tryMap({ baseResponse in
                Log.d(baseResponse, fileName: fileName, line: line, funcName: funcName)
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

    /// `data` 필드가 null/누락된 응답(예: 단순 성공 메시지만 내려오는 PUT/DELETE)을 위한 helper.
    /// status만 200대인지 검사하고, 본문은 무시합니다.
    public func mapBaseResponseEmpty(fileName: String = #file, line: Int = #line, funcName: String = #function) -> AnyPublisher<Void, Error> {
        return map(BaseResponse<BlankData>.self)
            .tryMap({ baseResponse in
                Log.d(baseResponse, fileName: fileName, line: line, funcName: funcName)
                guard (200..<300).contains(baseResponse.status) else {
                    throw NetworkError.httpStatusCode(baseResponse.serverError)
                }
                return ()
            })
            .eraseToAnyPublisher()
    }
    
    public func logged(fileName: String = #fileID, line: Int = #line, funcName: String = #function) -> AnyPublisher<Output, Failure> {
        return self.handleEvents(receiveOutput: { output in
            Log.d(output.statusCode, output.response, String(data: output.data, encoding: .utf8), fileName: fileName, line: line, funcName: funcName)
        }, receiveCompletion: { completion in
            if case let .failure(error) = completion {
                Log.e(error.localizedDescription, fileName: fileName, line: line, funcName: funcName)
            }
        })
        .eraseToAnyPublisher()
    }
}
