//
//  TermsAgreementViewController.swift
//  Presentation
//
//  Created by 김호성 on 2026.05.27.
//

import UIKit

import Domain

import View
import ViewModel

public protocol TermsAgreementViewControllerFactory {
    func makeTermsAgreementViewController() -> TermsAgreementViewController
}

public final class TermsAgreementViewController: BaseViewController<TermsAgreementView> {
    
    // MARK: - ViewModel
    
    private let onboardingViewModel: OnboardingViewModel
    
    // MARK: - DataSource
    
    private var termAgreementsCollectionViewDataSource: TermAgreementsCollectionViewDataSource?
    
    // MARK: - Basic
    
    public init(onboardingViewModel: OnboardingViewModel, viewControllerFactory: ViewControllerFactory) {
        self.onboardingViewModel = onboardingViewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func bind() {
        onboardingViewModel.agreedTerms.sink { [weak self] agreedTerms in
            guard let self else { return }
            let isAllAgreed = agreedTerms.values.allSatisfy { $0 }
            rootView.allAgreeCheckbox.isSelected = isAllAgreed
            rootView.nextButton.isEnabled = isAllAgreed
            termAgreementsCollectionViewDataSource?.apply(makeTermAgreementsCollectionViewSnapshot(), animatingDifferences: false)
        }
        .store(in: &cancellables)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(left: .back))
        
        setupTermAgreementsCollectionView()
        
        rootView.allAgreeCheckbox.addTarget(self, action: #selector(touchUpInsideAllAgreeCheckbox(_:)), for: .touchUpInside)
        rootView.nextButton.addTarget(self, action: #selector(touchUpInsideNextButton(_:)), for: .touchUpInside)
    }
    
    @objc private func touchUpInsideAllAgreeCheckbox(_ sender: UIButton) {
        let isAllAgreed = onboardingViewModel.agreedTerms.value.values.allSatisfy({ $0 })
        onboardingViewModel.agreedTerms.value = onboardingViewModel.agreedTerms.value.mapValues { _ in !isAllAgreed }
    }
    
    @objc private func touchUpInsideNextButton(_ sender: UIButton) {
        guard let nicknameViewController = viewControllerFactory?.makeNicknameViewController(onboardingViewModel: onboardingViewModel) else { return }
        navigationController?.pushViewController(nicknameViewController, animated: true)
    }
}

extension TermsAgreementViewController {
    
    private typealias TermAgreementsCollectionViewDataSource = UICollectionViewDiffableDataSource<TermAgreementsCollectionViewSection, TermAgreementsCollectionViewItem>
    private typealias TermAgreementsCollectionViewSnapshot = NSDiffableDataSourceSnapshot<TermAgreementsCollectionViewSection, TermAgreementsCollectionViewItem>
    
    private enum TermAgreementsCollectionViewSection: Sendable {
        case main
    }
    
    private enum TermAgreementsCollectionViewItem: Hashable, Sendable {
        case term(SignUpTerm, agreed: Bool)
    }
    
    private func setupTermAgreementsCollectionView() {
        let termAgreementCollectionViewCellRegistration = UICollectionView.CellRegistration<TermAgreementCollectionViewCell, (SignUpTerm, Bool)> { [weak self] cell, indexPath, item in
            let signUpTerm = item.0
            let agreed = item.1
            cell.configure(signUpTerm)
            cell.termAgreeCheckbox.isSelected = agreed
            cell.termAgreeCheckbox.addAction(UIAction(handler: { [weak self, weak sender = cell.termAgreeCheckbox] action in
                guard let self, let sender, let term = SignUpTerm(id: indexPath.row+1) else { return }
                sender.isSelected.toggle()
                onboardingViewModel.agreedTerms.value[term] = sender.isSelected
            }), for: .touchUpInside)
        }
        
        rootView.termAgreementsCollectionView.dataSource = termAgreementsCollectionViewDataSource
        
        termAgreementsCollectionViewDataSource = TermAgreementsCollectionViewDataSource(collectionView: rootView.termAgreementsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .term(signUpTerm, agreed):
                return collectionView.dequeueConfiguredReusableCell(using: termAgreementCollectionViewCellRegistration, for: indexPath, item: (signUpTerm, agreed: agreed))
            }
        })
        termAgreementsCollectionViewDataSource?.apply(makeTermAgreementsCollectionViewSnapshot())
    }
    
    private func makeTermAgreementsCollectionViewSnapshot() -> TermAgreementsCollectionViewSnapshot {
        var snapshot = TermAgreementsCollectionViewSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(SignUpTerm.allCases.map { .term($0, agreed: onboardingViewModel.agreedTerms.value[$0] ?? false) }, toSection: .main)
        return snapshot
    }
}
