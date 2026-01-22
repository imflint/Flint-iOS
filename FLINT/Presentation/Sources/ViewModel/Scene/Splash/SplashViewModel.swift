//
//  SplashViewModel.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//


import Combine

public final class SplashViewModel: BaseViewModelType {

    public struct Input {
        public let viewDidAppear: AnyPublisher<Void, Never>
        public let lottieFinished: AnyPublisher<Void, Never>

        public init(
            viewDidAppear: AnyPublisher<Void, Never>,
            lottieFinished: AnyPublisher<Void, Never>
        ) {
            self.viewDidAppear = viewDidAppear
            self.lottieFinished = lottieFinished
        }
    }

    public struct Output {
        /// SplashViewController가 이 이벤트 받으면 rootView.play() 호출
        public let playLottie: AnyPublisher<Void, Never>

        /// SplashViewController / Coordinator가 이 이벤트 받으면 Login으로 전환
        public let routeToLogin: AnyPublisher<Void, Never>
    }

    public init() {}

    public func transform(input: Input) -> Output {
        let playLottie = input.viewDidAppear
            .prefix(1)
            .eraseToAnyPublisher()

        let routeToLogin = input.lottieFinished
            .prefix(1)
            .eraseToAnyPublisher()

        return Output(
            playLottie: playLottie,
            routeToLogin: routeToLogin
        )
    }
}
