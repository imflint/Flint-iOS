//
//  BaseService.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

import Combine
import Moya

public class BaseService<API: TargetType> {
    private let provider: MoyaProvider<API>
    private let decoder: JSONDecoder

    public init(provider: MoyaProvider<API> = NetworkProvider.make(),
                decoder: JSONDecoder = NetworkEnvironment.config.decoder) {
        self.provider = provider
        self.decoder = decoder
    }

    public func request<T: Decodable>(_ target: API, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        let subject = PassthroughSubject<T, NetworkError>()

        let cancellable = provider.request(target) { [decoder] result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try decoder.decode(T.self, from: response.data)
                    subject.send(decoded)
                    subject.send(completion: .finished)
                } catch {
                    subject.send(completion: .failure(.decoding))
                }

            case .failure(let error):
                if case let .statusCode(response) = error {
                    subject.send(completion: .failure(Self.mapStatusCode(response: response, decoder: decoder)))
                    return
                }

                subject.send(completion: .failure(Self.mapUnderlying(error)))
            }
        }

        return subject
            .handleEvents(receiveCancel: { cancellable.cancel() })
            .eraseToAnyPublisher()
    }

    public func requestPlain(_ target: API) -> AnyPublisher<Void, NetworkError> {
        let subject = PassthroughSubject<Void, NetworkError>()

        let cancellable = provider.request(target) { [decoder] result in
            switch result {
            case .success:
                subject.send(())
                subject.send(completion: .finished)

            case .failure(let error):
                if case let .statusCode(response) = error {
                    subject.send(completion: .failure(Self.mapStatusCode(response: response, decoder: decoder)))
                    return
                }
                subject.send(completion: .failure(Self.mapUnderlying(error)))
            }
        }

        return subject
            .handleEvents(receiveCancel: { cancellable.cancel() })
            .eraseToAnyPublisher()
    }

    // MARK: - Error mapping

    private static func mapStatusCode(response: Response, decoder: JSONDecoder) -> NetworkError {
        switch response.statusCode {
        case 401:
            return .unauthorized

        case 400..<500:
            if let serverError = try? decoder.decode(ServerError.self, from: response.data) {
                return .server(serverError)
            }
            return .badRequest

        case 500..<600:
            if let serverError = try? decoder.decode(ServerError.self, from: response.data) {
                return .server(serverError)
            }
            return .server(ServerError(code: response.statusCode, message: "Server Error"))

        default:
            return .unknown
        }
    }

    private static func mapUnderlying(_ error: MoyaError) -> NetworkError {
        if case let .underlying(err, _) = error, let urlError = err as? URLError {
            switch urlError.code {
            case .timedOut:
                return .timeout
            case .notConnectedToInternet, .cannotFindHost, .cannotConnectToHost, .networkConnectionLost:
                return .networkFail
            default:
                return .networkFail
            }
        }
        return .unknown
    }
}
