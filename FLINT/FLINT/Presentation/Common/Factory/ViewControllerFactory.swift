//
//  ViewControllerFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import UIKit

protocol ViewControllerFactory {
    func makeExampleViewController() -> ExampleViewController
}

final class ViewControllerFactoryImpl: ViewControllerFactory {

    private let container: AppDIContainer

    init(container: AppDIContainer) {
        self.container = container
    }

    func makeExampleViewController() -> ExampleViewController {
        let useCase = container.makeExampleUseCase()
        let viewModel = ExampleViewModel(useCase: useCase)
        return ExampleViewController(viewModel: viewModel)
    }
}
