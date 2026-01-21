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

typealias AppFactory = ViewControllerFactory & OnboardingFactory  & CreateCollectionFactory & HomeFactory

final class DIContainer: AppFactory {
    
    // MARK: - Root Dependency
    
    private lazy var userAPIProvider = MoyaProvider<UserAPI>()
//    private lazy var searchService: SearchService = DefaultSearchService()
    private lazy var collectionAPIProvider = MoyaProvider<CollectionAPI>()
    private lazy var homeAPIProvider = MoyaProvider<HomeAPI>()
    
    private lazy var authInterceptor: AuthInterceptor = AuthInterceptor(tokenStorage: tokenStorage)
    private lazy var networkLoggerPlugin: NetworkLoggerPlugin = NetworkLoggerPlugin()
    
    private lazy var userAPIProvider = MoyaProvider<UserAPI>(
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
    
    func makeNicknameViewController(onboardingViewModel: OnboardingViewModel) -> NicknameViewController {
        return NicknameViewController(onboardingViewModel: makeOnboardingViewModel(), viewControllerFactory: self)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let vm = makeHomeViewModel(userName: "얀비") // TODO: 실제 유저명 연결
        return HomeViewController(viewModel: vm)
    }
    
    func makeCreateCollectionViewController() -> CreateCollectionViewController {
        return CreateCollectionViewController(viewModel: makeCreateCollectionViewModel(), viewControllerFactory: self)
    }
    
    // MARK: - Root Dependency Injection
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
    
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI> {
        collectionAPIProvider
    }
    
    func makeHomeAPIProvider() -> MoyaProvider<HomeAPI> {
        homeAPIProvider
    }
}
