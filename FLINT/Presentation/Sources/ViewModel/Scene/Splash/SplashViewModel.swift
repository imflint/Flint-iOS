//
//  SplashViewModel.swift
//  Presentation
//
//  Created by Hosung.Kim on 2026.08.23.
//

import Combine
import Foundation

import Domain

public enum SplashRoute {
    case login
    case home
}

public protocol SplashViewModelInput {
    func refresh()
}

public protocol SplashViewModelOutput {
    var route: PassthroughSubject<SplashRoute, Never> { get }
}

public typealias SplashViewModel = SplashViewModelInput & SplashViewModelOutput

public final class DefaultSplashViewModel: SplashViewModel {
    
    private let refreshUseCase: RefreshUseCase
    
    public let route: PassthroughSubject<SplashRoute, Never> = .init()
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(refreshUseCase: RefreshUseCase) {
        self.refreshUseCase = refreshUseCase
    }
    
    public func refresh() {
        refreshUseCase()
            .manageThread()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.route.send(.home)
                case .failure:
                    self?.route.send(.login)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
