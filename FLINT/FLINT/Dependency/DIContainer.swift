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

typealias AppFactory = ViewControllerFactory & OnboardingViewModelFactory & ExploreViewModelFactory & CreateCollectionFactory & AddContentSelectViewModelFactory & ProfileFactory & HomeFactory & CollectionDetailFactory & LoginViewModelFactory

final class DIContainer: AppFactory {
    func makeHomeViewModel(homeUseCase: any UseCase.HomeUseCase) -> ViewModel.HomeViewModel {
        return makeHomeViewModel(homeUseCase: makeHomeUseCase())
    }
    
    
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
        tokenStorage.clearAll()
    }
    
    // MARK: - ViewControllerFactory
    
    func makeSplashViewController() -> SplashViewController {
        return SplashViewController(viewControllerFactory: self)
    }
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(loginViewModel: makeLoginViewModel(), viewControllerFactory: self)
    }
    
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
        let vm = makeHomeViewModel()
        return HomeViewController(viewModel: vm, viewControllerFactory: self)
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

    
    func makeProfileViewController() -> ProfileViewController {
        makeProfileViewController(target: .me)
    }

    func makeProfileViewController(
        target: ProfileViewModel.Target = .me
    ) -> ProfileViewController {
        return ProfileViewController(
            profileViewModel: makeProfileViewModel(target: target),
            viewControllerFactory: self
        )
    }

    
//    func makeCollectionDetailViewController(collectionId: Int64) -> CollectionDetailViewController {
//        let vm = makeCollectionDetailViewModel(collectionId: collectionId)
//        return CollectionDetailViewController(viewModel: vm)
//    }
    func makeCollectionDetailViewController(collectionId: Int64) -> CollectionDetailViewController {
        let vm = makeCollectionDetailViewModel(collectionId: collectionId)
        return CollectionDetailViewController(viewModel: vm, viewControllerFactory: self)
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
    
    func makeHomeAPIProvider() -> Moya.MoyaProvider<Networking.HomeAPI> {
        return homeAPIProvider
    }
}
