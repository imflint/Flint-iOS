//
//  OnboardingDoneViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

import Domain

import View
import ViewModel

public final class OnboardingDoneViewController: BaseViewController<OnboardingDoneView> {
    
    // MARK: - ViewModel
    
    private let onboardingViewModel: OnboardingViewModel
    
    // MARK: - Basic
    
    public init(onboardingViewModel: OnboardingViewModel, viewControllerFactory: ViewControllerFactory) {
        self.onboardingViewModel = onboardingViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(.init(left: .back))
        rootView.startButton.addAction(UIAction(handler: completeOnboarding(_:)), for: .touchUpInside)
    }
    
    public override func bind() {
        onboardingViewModel.userId.sink(receiveValue: { [weak self] userId in
            Log.d(userId)
            guard let userId, let tabBarViewController = self?.viewControllerFactory?.makeTabBarViewController() else { return }
            self?.navigationController?.setViewControllers([tabBarViewController], animated: false)
        })
        .store(in: &cancellables)
    }
    
    private func completeOnboarding(_ action: UIAction) {
        onboardingViewModel.signup()
    }
}
