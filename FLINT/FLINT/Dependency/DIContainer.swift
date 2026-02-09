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

typealias DependencyFactory = ViewControllerFactory &
                              
                              LoginViewModelFactory &
                              OnboardingViewModelFactory &
                              
                              HomeViewModelFactory &
                              ExploreViewModelFactory &
                              ProfileViewModelFactory &
                              
                              CreateCollectionViewModelFactory &
                              AddContentSelectViewModelFactory &
                              CollectionFolderListViewModelFactory &
                              CollectionDetailViewModelFactory

final class DIContainer: DependencyFactory {
    
    // MARK: - Root Dependency
    
//    lazy var tokenStorage: TokenStorage = DefaultTokenStorage()
    lazy var tokenStorage: TokenStorage = TestTokenStorage()
    
    private lazy var authInterceptor: AuthInterceptor = AuthInterceptor(tokenStorage: tokenStorage)
    private lazy var networkLoggerPlugin: NetworkLoggerPlugin = NetworkLoggerPlugin()
    
    lazy var contentAPIProvider = MoyaProvider<ContentAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    lazy var userAPIProvider = MoyaProvider<UserAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    lazy var collectionAPIProvider = MoyaProvider<CollectionAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    lazy var searchAPIProvider = MoyaProvider<SearchAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    lazy var bookmarkAPIProvider = MoyaProvider<BookmarkAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )

    lazy var authAPIProvider = MoyaProvider<AuthAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    
    lazy var homeAPIProvider = MoyaProvider<HomeAPI>(
        session: Session(interceptor: authInterceptor),
        plugins: [
            networkLoggerPlugin
        ]
    )
    
    // MARK: - Init
    
    init() {
//        tokenStorage.clearAll()
    }
}
