//
//  DIContainer.swift
//  CleanArchitectureMVVM
//
//  Created by 김호성 on 2025.12.05.
//

import Foundation
import Combine

//import Data
//import Domain
import Presentation

protocol AppFactory: ViewControllerFactory { }

final class DIContainer: AppFactory {
    
    private let apiKey: String
    
    // MARK: - Root Dependency
//    private lazy var catService: CatService = DefaultCatService(apiKey: apiKey)
    
    // MARK: - Init
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - ViewControllerFactory
//    func buildMainViewController(catViewModel: CatViewModel?) -> MainViewController {
//        return MainViewController.instantiate().configured({
//            $0.inject(catViewModel: catViewModel ?? buildCatViewModel())
//        })
//    }
    
//    func buildCatDetailViewController(index: Int, catViewModel: CatViewModel?) -> CatDetailViewController {
//        return CatDetailViewController.instantiate().configured({
//            $0.inject(index: index, catViewModel: catViewModel ?? buildCatViewModel())
//        })
//    }
    
    // MARK: - Root Dependency Injection
//    func buildCatRepository() -> CatRepository {
//        buildCatRepository(catService: catService)
//    }
}
