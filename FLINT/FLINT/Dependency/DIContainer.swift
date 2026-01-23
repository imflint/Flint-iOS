//
//  DIContainer.swift
//  CleanArchitectureMVVM
//
//  Created by 김호성 on 2025.12.05.
//

import UIKit
import Combine

import Alamofire
import Moya

import Data
import Domain
import Presentation

typealias AppFactory = ViewControllerFactory & OnboardingViewModelFactory & ExploreViewModelFactory

final class DIContainer: AppFactory {
    
    // MARK: - Root Dependency
    
    private lazy var tokenStorage: TokenStorage = DefaultTokenStorage()
    
    private lazy var authInterceptor: AuthInterceptor = AuthInterceptor(tokenStorage: tokenStorage)
    private lazy var networkLoggerPlugin: NetworkLoggerPlugin = NetworkLoggerPlugin()
    
    private lazy var userAPIProvider = MoyaProvider<UserAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    private lazy var collectionAPIProvider = MoyaProvider<CollectionAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    private lazy var searchAPIProvider = MoyaProvider<SearchAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - ViewControllerFactory
    
    func makeTabBarViewController() -> TabBarViewController {
        return TabBarViewController(viewControllerFactory: self)
    }
    
    func makeNicknameViewController() -> NicknameViewController {
        return NicknameViewController(onboardingViewModel: makeOnboardingViewModel(), viewControllerFactory: self)
    }
    
    func makeFilmSelectViewController(onboardingViewModel: OnboardingViewModel) -> FilmSelectViewController {
        return FilmSelectViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
    
    func makeOttSelectViewController(onboardingViewModel: OnboardingViewModel) -> OttSelectViewController {
        return OttSelectViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
    
    func makeOnboardingDoneViewController(onboardingViewModel: OnboardingViewModel) -> OnboardingDoneViewController {
        return OnboardingDoneViewController(onboardingViewModel: onboardingViewModel, viewControllerFactory: self)
    }
    
    func makeExploreViewController() -> ViewController.ExploreViewController {
        return ExploreViewController(exploreViewModel: makeExploreViewModel(), viewControllerFactory: self)
    }
    
    // MARK: - Root Dependency Injection
    
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
    
    func makeCollectionAPIProvider() -> Moya.MoyaProvider<Networking.CollectionAPI> {
        return collectionAPIProvider
    }
    
    func makeSearchAPIProvider() -> Moya.MoyaProvider<Networking.SearchAPI> {
        return searchAPIProvider
    }
}
