//
//  OttSelectViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

import Domain

import View
import ViewModel

public class OttSelectViewController: BaseViewController<OttSelectView> {
    
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
        
        setNavigationBar(.init(left: .back, right: .text(title: "건너뛰기", color: DesignSystem.Color.secondary400)), onTapRight: { [weak self] in
            self?.onboardingViewModel.selectedOtt.value.removeAll()
            self?.pushOnboardingDoneViewController()
        })
        rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "얀비 님이 구독 중인 OTT 서비스를 알려주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        rootView.ottCollectionView.dataSource = self
        rootView.ottCollectionView.delegate = self
        rootView.nextButton.addAction(UIAction(handler: pushOnboardingDoneViewController(_:)), for: .touchUpInside)
    }
    
    public override func bind() {
        onboardingViewModel.selectedOtt.sink(receiveValue: { [weak self] otts in
            self?.rootView.ottCollectionView.reloadData()
        })
        .store(in: &cancellables)
    }
    
    private func pushOnboardingDoneViewController(_ action: UIAction) {
        pushOnboardingDoneViewController()
    }
    private func pushOnboardingDoneViewController() {
        guard let onboardingDoneViewController = viewControllerFactory?.makeOnboardingDoneViewController(onboardingViewModel: onboardingViewModel) else { return }
        navigationController?.pushViewController(onboardingDoneViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension OttSelectViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Ott.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingOttCollectionViewCell.reuseIdentifier, for: indexPath) as? OnboardingOttCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let ott = Ott(rawValue: indexPath.item) else {
            return cell
        }
        
        let isSelectedOtt = onboardingViewModel.selectedOtt.value.contains(where: {
            $0 == ott
        })
        
        cell.overlayView.isHidden = !isSelectedOtt
        cell.titleLabel.textColor = isSelectedOtt ? DesignSystem.Color.gray300 : DesignSystem.Color.white
        
        cell.imageView.image = ott.logo
        cell.titleLabel.attributedText = .pretendard(.body1_m_16, text: ott.korTitle, alignment: .center)
        return cell
    }
}

extension OttSelectViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let ott = Ott(rawValue: indexPath.item) else { return }
        onboardingViewModel.clickOtt(ott)
    }
}
