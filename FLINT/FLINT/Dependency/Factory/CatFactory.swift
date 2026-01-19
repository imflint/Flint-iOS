//
//  CatFactory.swift
//  CleanArchitectureMVVM
//
//  Created by 김호성 on 2025.12.05.
//

import Foundation


import Presentation

//protocol CatFactory {
//    func buildCatRepository() -> CatRepository
//    func buildCatRepository(catService: CatService) -> CatRepository
//    
//    func buildCatUseCase() -> CatUseCase
//    func buildCatUseCase(catRepository: CatRepository) -> CatUseCase
//    
//    func buildCatViewModel() -> CatViewModel
//    func buildCatViewModel(catUseCase: CatUseCase) -> CatViewModel
//}
//
//extension CatFactory {
//    func buildCatRepository(catService: CatService) -> CatRepository {
//        return DefaultCatRepository(catService: catService)
//    }
//    
//    func buildCatUseCase() -> CatUseCase {
//        return DefaultCatUseCase(catRepository: buildCatRepository())
//    }
//    func buildCatUseCase(catRepository: CatRepository) -> CatUseCase {
//        return DefaultCatUseCase(catRepository: catRepository)
//    }
//    
//    func buildCatViewModel() -> CatViewModel {
//        return DefaultCatViewModel(catUseCase: buildCatUseCase())
//    }
//    func buildCatViewModel(catUseCase: CatUseCase) -> CatViewModel {
//        return DefaultCatViewModel(catUseCase: catUseCase)
//    }
//}
