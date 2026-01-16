//
//  ExampleViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/7/26.
//

import Combine
import UIKit

final class ExampleViewController: BaseViewController<ExampleView> {

    private let viewModel: ExampleViewModel

    private var cancellables = Set<AnyCancellable>()
    private let tapSubject = PassthroughSubject<Void, Never>()

    init(viewModel: ExampleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.onTapButton = { [weak self] in
            self?.tapSubject.send(())
        }

        let input = ExampleViewModel.Input(didTapFetch: tapSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.fetchResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] res in
                self?.rootView.setLabel(res.title, team: res.team)
            }
            .store(in: &cancellables)
    }
}
