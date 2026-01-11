//
//  AppDIContainer.swift
//  FLINT
//
//  Created by 진소은 on 1/4/26.
//

import Foundation
import Combine

import Moya

final class AppDIContainer {

    static let shared = AppDIContainer()
    private init() {}

    func configureNetworking() {
        let baseURL = URL(string: "https://55a1001b-fac4-4450-bcc3-559f8051a97d.mock.pstmn.io")!
        let decoder = JSONDecoder()

        NetworkEnvironment.configure(
            NetworkConfig(
                baseURL: baseURL,
                defaultHeaders: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ],
                decoder: decoder
            )
        )
    }

    // MARK: - Service
    
    func makeExampleService() -> ExampleService {
         return ExampleServiceImpl()
    }

    // MARK: - Repository
    
    func makeExampleRepository() -> ExampleRepository {
        ExampleRepositoryImpl(
            service: makeExampleService()
        )
    }

    // MARK: - UseCase
    
    func makeExampleUseCase() -> ExampleUseCase {
        ExampleUseCaseImpl(repository: makeExampleRepository())
    }

    // MARK: - ViewModel
    
    func makeExampleViewModel() -> ExampleViewModel {
        return ExampleViewModel(useCase: makeExampleUseCase())
    }
}
