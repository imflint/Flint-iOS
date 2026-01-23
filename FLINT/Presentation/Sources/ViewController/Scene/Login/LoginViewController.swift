//
//  LoginViewController.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import UIKit

import Domain

import View
import ViewModel

public final class LoginViewController: BaseViewController<LoginView> {
    
    // MARK: - ViewModel
    
    private let loginViewModel: LoginViewModel
    
    public init(loginViewModel: LoginViewModel, viewControllerFactory: ViewControllerFactory) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.kakaoButton.addAction(UIAction(handler: kakaoLogin(_:)), for: .touchUpInside)
    }
    
    public override func bind() {
        loginViewModel.socialVerifyResultEntity.sink { [weak self] socialVerifyResultEntity in
            Log.d(socialVerifyResultEntity)
            if let socialVerifyResultEntity, !socialVerifyResultEntity.isRegistered {
                self?.register()
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
        guard let nicknameViewController = viewControllerFactory?.makeNicknameViewController() else { return }
        navigationController?.pushViewController(nicknameViewController, animated: true)
    }
}
