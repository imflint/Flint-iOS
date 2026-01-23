//
//  LoginViewController.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import UIKit

import View

public final class LoginViewController: BaseViewController<LoginView> {
    
    public init(viewControllerFactory: ViewControllerFactory) {
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
    
    public override func setBaseLayout() {
        rootView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func kakaoLogin(_ action: UIAction) {
        guard let nicknameViewController = viewControllerFactory?.makeNicknameViewController() else { return }
        navigationController?.pushViewController(nicknameViewController, animated: true)
    }
}
