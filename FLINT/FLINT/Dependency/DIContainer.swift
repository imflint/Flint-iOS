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

typealias AppFactory = ViewControllerFactory & OnboardingFactory & SearchFactory & CreateCollectionFactory

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
    
    private lazy var searchAPIProvider = MoyaProvider<SearchAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [networkLoggerPlugin]
    )
    
    private lazy var collectionAPIProvider = MoyaProvider<CollectionAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [networkLoggerPlugin]
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
    
    func makeAddContentSelectViewController() -> AddContentSelectViewController {
        let vm = makeAddContentSelectViewModel()
        return AddContentSelectViewController(viewModel: vm, viewControllerFactory: self)
    }
    
    func makeCreateCollectionViewController() -> CreateCollectionViewController {
        let vm = makeCreateCollectionViewModel()
        return CreateCollectionViewController(viewModel: vm, viewControllerFactory: self)
    }
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController()
    }
    
    // MARK: - Root Dependency Injection
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
    
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI> {
        return searchAPIProvider
    }
    
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI> {
        return collectionAPIProvider
    }
}
