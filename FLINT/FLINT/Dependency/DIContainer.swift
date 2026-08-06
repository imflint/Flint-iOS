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
                              FetchOTTPlatformsForContentUseCaseFactory &  
                              ExploreViewModelFactory &
                              ProfileViewModelFactory &

                              SettingViewModelFactory &
                              WithdrawViewModelFactory &
                              
                              CreateCollectionViewModelFactory &
                              AddContentSelectViewModelFactory &
                              CollectionFolderListViewModelFactory &
                              CollectionDetailViewModelFactory &
                              SavedCollectionListViewModelFactory&
                              ReportViewModelFactory & 
                              StorageRepositoryFactory &
                              UploadCollectionImageUseCaseFactory

final class DIContainer: DependencyFactory {
    
    // MARK: - Root Dependency
    
    private lazy var authInterceptor: AuthInterceptor = AuthInterceptor(tokenStorage: tokenStorage)
    private lazy var networkLoggerPlugin: NetworkLoggerPlugin = NetworkLoggerPlugin()
    
    private lazy var session: Session = Session(interceptor: authInterceptor)
    private lazy var plugins: [PluginType] = []
//    private lazy var plugins: [PluginType] = [networkLoggerPlugin]
    
    lazy var authAPIProvider = MoyaProvider<AuthAPI>(session: session, plugins: plugins)
    lazy var bookmarkAPIProvider = MoyaProvider<BookmarkAPI>(session: session, plugins: plugins)
    lazy var collectionAPIProvider = MoyaProvider<CollectionAPI>(session: session, plugins: plugins)
    lazy var contentAPIProvider = MoyaProvider<ContentAPI>(session: session, plugins: plugins)
    lazy var homeAPIProvider = MoyaProvider<HomeAPI>(session: session, plugins: plugins)
    lazy var searchAPIProvider = MoyaProvider<SearchAPI>(session: session, plugins: plugins)
    lazy var storageAPIProvider = MoyaProvider<StorageAPI>(session: session, plugins: plugins)
    lazy var userAPIProvider = MoyaProvider<UserAPI>(session: session, plugins: plugins)
    
    lazy var tokenStorage: TokenStorage = DefaultTokenStorage()
//    lazy var tokenStorage: TokenStorage = TestTokenStorage()
    
    lazy var presignedUrlService: any PresignedUrlService = DefaultPresignedUrlService()
    
    // MARK: - Init
    
    init() {
//        tokenStorage.clearAll()
    }
}
