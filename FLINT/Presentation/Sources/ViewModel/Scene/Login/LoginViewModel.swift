//
//  LoginViewModel.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//


import Combine

public final class LoginViewModel: BaseViewModelType {

    public struct Input {
        public let tapKakao: AnyPublisher<Void, Never>

        public init(tapKakao: AnyPublisher<Void, Never>) {
            self.tapKakao = tapKakao
        }
    }

    public struct Output {
        /// Coordinator/VC가 이 이벤트 받으면 카카오 로그인 플로우 시작
        public let routeToKakaoLogin: AnyPublisher<Void, Never>
    }

    public init() {}

    public func transform(input: Input) -> Output {
        let routeToKakaoLogin = input.tapKakao
            .eraseToAnyPublisher()

        return Output(routeToKakaoLogin: routeToKakaoLogin)
    }
}
