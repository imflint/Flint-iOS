//
//  LoginViewController.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import AuthenticationServices
import UIKit

import Domain

import View
import ViewModel

public protocol LoginViewControllerFactory {
    func makeLoginViewController() -> LoginViewController
}

public final class LoginViewController: BaseViewController<LoginView> {
    
    // MARK: - ViewModel
    
    private let loginViewModel: LoginViewModel
    
    public init(loginViewModel: LoginViewModel, viewControllerFactory: ViewControllerFactory) {
        self.loginViewModel = loginViewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.kakaoButton.addAction(UIAction(weak: self, handler: LoginViewController.kakaoLogin(_:)), for: .touchUpInside)
        rootView.appleButton.addAction(UIAction(weak: self, handler: LoginViewController.appleLogin(_:)), for: .touchUpInside)
    }
    
    public override func bind() {
        loginViewModel.socialVerifyResultEntity.sink { [weak self] socialVerifyResultEntity in
            Log.d(socialVerifyResultEntity)
            if !socialVerifyResultEntity.isRegistered {
                self?.register()
            } else {
                self?.pushToTabBar()
            }
        }
        .store(in: &cancellables)
    }
    
    public override func setBaseLayout() {
        rootView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func kakaoLogin(_ action: UIAction) {
        loginViewModel.kakaoLogin()
    }
    
    private func register() {
        guard let termsAgreementViewController = viewControllerFactory?.makeTermsAgreementViewController() else { return }
        navigationController?.pushViewController(termsAgreementViewController, animated: true)
    }
    
    private func pushToTabBar() {
        guard let tabBarViewController = viewControllerFactory?.makeTabBarViewController() else { return }
        navigationController?.setViewControllers([tabBarViewController], animated: false)
    }
    
    private func appleLogin(_ action: UIAction) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        Log.e(error)
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            Log.d(String(data: appleIdCredential.identityToken!, encoding: .utf8))
            Log.d(String(data: appleIdCredential.authorizationCode!, encoding: .utf8))
        default: break
        }
    }
}
