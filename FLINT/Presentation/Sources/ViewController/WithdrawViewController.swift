//
//  WithdrawViewController.swift
//  Presentation
//
//  Created by 소은 on 5/13/26.
//

import UIKit

import Combine

import View
import ViewModel

public protocol WithdrawalViewControllerFactory {
    func makeWithdrawalViewController() -> WithdrawalViewController
}

public final class WithdrawalViewController: BaseViewController<WithdrawalView> {
    
    // MARK: - Property
    
    private let viewModel: WithdrawViewModel
    
    private let agreementCheckSubject = PassthroughSubject<Bool, Never>()
    private let withdrawButtonSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    
    public init(viewModel: WithdrawViewModel, viewControllerFactory: (any ViewControllerFactory)?) {
        self.viewModel = viewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
    }
    
    // MARK: - Override
    
    public override func setUI() {
        view.backgroundColor = DesignSystem.Color.background
    }
    
    public override func bind() {
        let input = WithdrawViewModel.Input(
            agreementCheckTapped: agreementCheckSubject.eraseToAnyPublisher(),
            withdrawButtonTapped: withdrawButtonSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isWithdrawEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.rootView.withdrawButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        output.withdrawSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                guard let loginVC = viewControllerFactory?.makeLoginViewController() else { return }
                let nav = UINavigationController(rootViewController: loginVC)
                nav.modalPresentationStyle = .fullScreen
                if let window = view.window {
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                        window.rootViewController = nav
                    }
                }
            }
            .store(in: &cancellables)
        
        output.withdrawError
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("탈퇴 실패: \(error)")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        setNavigationBar(.init(
            left: .back,
            title: "탈퇴하기"
        ))
    }
    
    private func setupActions() {
        rootView.agreementCheckBox.didTapCheckBox = { [weak self] isSelected in
            self?.agreementCheckSubject.send(isSelected)
        }
        
        rootView.withdrawButton.addAction(UIAction { [weak self] _ in
            self?.withdrawButtonSubject.send(())
        }, for: .touchUpInside)
    }
}
