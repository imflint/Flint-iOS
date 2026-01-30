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

typealias DependencyFactory = ViewControllerFactory & OnboardingViewModelFactory & ExploreViewModelFactory & CreateCollectionFactory & AddContentSelectViewModelFactory & ProfileFactory & HomeFactory & CollectionDetailFactory & LoginViewModelFactory

final class DIContainer: DependencyFactory {
    
    // MARK: - Root Dependency
    
//    private lazy var tokenStorage: TokenStorage = DefaultTokenStorage()
    private lazy var tokenStorage: TokenStorage = TestTokenStorage()
    
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
    private lazy var bookmarkAPIProvider = MoyaProvider<BookmarkAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )

    private lazy var authAPIProvider = MoyaProvider<AuthAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    
    private lazy var homeAPIProvider = MoyaProvider<HomeAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    
    // MARK: - Init
    
    init() {
//        tokenStorage.clearAll()
    }
    
    // MARK: - Root Dependency Injection
    
    func makeTokenStorage() -> TokenStorage {
        return tokenStorage
    }
    
    func makeUserAPIProvider() -> MoyaProvider<UserAPI> {
        return userAPIProvider
    }
    
    func makeSearchAPIProvider() -> MoyaProvider<SearchAPI> {
        return searchAPIProvider
    }
    
    func makeCollectionAPIProvider() -> MoyaProvider<CollectionAPI> {
        return collectionAPIProvider
    }
    
    func makeBookmarkAPIProvider() -> MoyaProvider<BookmarkAPI> {
        return bookmarkAPIProvider
    }
    
    func makeAuthAPIProvider() -> MoyaProvider<AuthAPI> {
        return authAPIProvider
    }
    
    func makeHomeAPIProvider() -> MoyaProvider<HomeAPI> {
        return homeAPIProvider
    }
}
