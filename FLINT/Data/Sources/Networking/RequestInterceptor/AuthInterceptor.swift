//
//  AuthInterceptor.swift
//  Data
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

import Alamofire

import DTO

public final class AuthInterceptor: RequestInterceptor {
    
    private let tokenStorage: TokenStorage
    
    public init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = tokenStorage.load(type: .accessToken) {
            urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
        // TODO: - RefreshToken 자동화 & 자동 로그인
//        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
//            completion(.doNotRetry)
//            return
//        }
//
//        guard let refreshToken = tokenStorage.load(type: .refreshToken) else {
//            tokenStorage.clearAll()
//            completion(.doNotRetry)
//            return
//        }
//
//        provider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
//            switch result {
//            case .success(let response):
//                do {
//                    let reissueResponse = try response.map(<ReissueModel>.self)
//                    if reissueResponse.success, let data = reissueResponse.data {
//                        self?.authService.saveAccessToken(data.accessToken)
//                        self?.authService.saveRefreshToken(data.refreshToken)
//                        completion(.retry)
//                    } else {
//                        self?.authService.clearTokens()
//                        completion(.doNotRetry)
//                    }
//                } catch {
//                    self?.authService.clearTokens()
//                    completion(.doNotRetry)
//                }
//            case .failure:
//                self?.authService.clearTokens()
//                completion(.doNotRetry)
//            }
//        }
    }
}
