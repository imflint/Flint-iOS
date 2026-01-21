//
//  LoginViewController.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import UIKit

import View

public final class LoginViewController: BaseViewController<LoginView> {

    public override func viewDidLoad() {
        super.viewDidLoad()

        rootView.onTapKakao = { [weak self] in
            // MARK: - 카카오 로그인
        }
    }
    
    public override func setBaseLayout() {
        rootView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }}
