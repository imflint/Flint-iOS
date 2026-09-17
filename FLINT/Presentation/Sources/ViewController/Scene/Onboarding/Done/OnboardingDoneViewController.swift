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

public protocol OnboardingDoneViewControllerFactory {
    func makeOnboardingDoneViewController(onboardingViewModel: OnboardingViewModel) -> OnboardingDoneViewController
}

public final class OnboardingDoneViewController: BaseViewController<OnboardingDoneView> {
    
    // MARK: - ViewModel
    
    private let onboardingViewModel: OnboardingViewModel
    
    // MARK: - Basic
    
    public init(onboardingViewModel: OnboardingViewModel, viewControllerFactory: ViewControllerFactory) {
        self.onboardingViewModel = onboardingViewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(.init(left: .back))
        rootView.startButton.addAction(UIAction(weak: self, handler: OnboardingDoneViewController.completeOnboarding(_:)), for: .touchUpInside)

        AnalyticsService.shared.track(.viewOnboardingDone)
    }

    public override func bind() {
        onboardingViewModel.userId.sink(receiveValue: { [weak self] userId in
            Log.d(userId)
            guard let userId, let tabBarViewController = self?.viewControllerFactory?.makeTabBarViewController() else { return }
            let duration = AnalyticsService.shared.onboardingDurationSec()
            AnalyticsService.shared.setUserId(userId)
            AnalyticsService.shared.setUserProperty(.signupDate(Date()))
            AnalyticsService.shared.setUserProperty(.lastLoginDate(Date()))
            AnalyticsService.shared.setUserProperty(.userType(.user))
            AnalyticsService.shared.track(.completeOnboarding(durationSec: duration))
            AnalyticsService.shared.track(.completeSignup)
            AnalyticsService.shared.clearOnboardingStart()
            self?.navigationController?.setViewControllers([tabBarViewController], animated: false)
        })
        .store(in: &cancellables)
    }
    
    private func completeOnboarding(_ action: UIAction) {
        onboardingViewModel.signup()
    }
}
