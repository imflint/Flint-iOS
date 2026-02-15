//
//  ContentSelectViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit

import Domain

import View
import ViewModel

public protocol ContentSelectViewControllerFactory {
    func makeContentSelectViewController(onboardingViewModel: OnboardingViewModel) -> ContentSelectViewController
}

// TODO: - shadow

public final class ContentSelectViewController: BaseViewController<ContentSelectView> {
    
    // MARK: - Enum
    
    private enum ScrollDirection {
        case up
        case down
        
        init?(velocity: CGFloat) {
            if velocity > 0 {
                self = .up
            } else {
                self = .down
            }
        }
    }
    
    // MARK: - ViewModel
    
    private let onboardingViewModel: OnboardingViewModel
    
    // MARK: - Property
    
    private var offsetCorrection: CGFloat = 0
    private var foldableViewYOffset: CGFloat = 0
    
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
        
        setNavigationBar(.init(left: .back, backgroundStyle: .solid(DesignSystem.Color.background)))
        hideKeyboardWhenTappedAround(activeOnAction: false)
        
        onboardingViewModel.fetchPopularContents()
        
        rootView.searchTextField.searchAction = { [weak self] keyword in
            self?.onboardingViewModel.searchContents(keyword ?? "")
        }
        rootView.searchTextField.clearAction = { [weak self] in
            self?.onboardingViewModel.fetchPopularContents()
        }
        
        rootView.progressLabel.attributedText = .pretendard(.caption1_m_12, text: "\(onboardingViewModel.selectedContents.value.count)/\(onboardingViewModel.contentSelectQuestions.count)")
        rootView.progressView.progress = Float(onboardingViewModel.selectedContents.value.count) / Float(onboardingViewModel.contentSelectQuestions.count)
        rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "\(onboardingViewModel.nickname.value) 님이 좋아하는 작품 7개를 골라주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        rootView.subtitleLabel.attributedText = .pretendard(.body2_r_14, text: onboardingViewModel.contentSelectQuestions[onboardingViewModel.selectedContents.value.count])
        rootView.selectedContentCollectionView.dataSource = self
        rootView.contentCollectionView.dataSource = self
        rootView.contentCollectionView.delegate = self
        rootView.searchTextField.delegate = self
        
        rootView.layoutIfNeeded()
        rootView.contentCollectionView.contentOffset.y = -rootView.contentCollectionView.contentInset.top
        
        rootView.contentCollectionView.panGestureRecognizer.addTarget(self, action: #selector(contentCollectionViewPanGesture))
        rootView.nextButton.addAction(UIAction(handler: pushOttSelectViewController(_:)), for: .touchUpInside)
    }
    
    public override func bind() {
        onboardingViewModel.nickname.sink { [weak self] nickname in
            guard let self else { return }
            rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "\(onboardingViewModel.nickname.value) 님이 좋아하는 작품 7개를 골라주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        }
        .store(in: &cancellables)
        
        onboardingViewModel.contents.sink { [weak self] contents in
            self?.rootView.emptyView.isHidden = !contents.isEmpty
            self?.rootView.contentCollectionView.reloadData()
        }
        .store(in: &cancellables)
        
        onboardingViewModel.selectedContents.sink { [weak self] selectedContents in
            guard let self else { return }
            UIView.animate(withDuration: 0.2, animations: {
                self.rootView.selectedContentCollectionView.isHidden = selectedContents.isEmpty
            })
            self.rootView.selectedContentCollectionView.reloadData()
            self.rootView.contentCollectionView.reloadData()
            rootView.progressLabel.attributedText = .pretendard(.caption1_m_12, text: "\(selectedContents.count)/\(onboardingViewModel.contentSelectQuestions.count)")
            rootView.progressView.progress = Float(selectedContents.count) / Float(onboardingViewModel.contentSelectQuestions.count)
            rootView.subtitleLabel.attributedText = .pretendard(.body2_r_14, text: onboardingViewModel.contentSelectQuestions[min(selectedContents.count, onboardingViewModel.contentSelectQuestions.count-1)])
            
            rootView.nextButton.isEnabled = selectedContents.count == 7
        }
        .store(in: &cancellables)
    }
    
    @objc public func contentCollectionViewPanGesture(_ sender: UIPanGestureRecognizer) {
        // Adjust the accumulated scroll translation
        // so that the foldableView responds immediately when the scroll direction changes
        let translationY = sender.translation(in: rootView.contentCollectionView).y
        let velocityY = sender.velocity(in: rootView.contentCollectionView).y
        
        let unclampedOffset = translationY - offsetCorrection
        
        // Update offsetCorrection value
        if unclampedOffset >= 0 {
            // When topBarView is visible
            // topBarViewOffsetY = translationY - offsetCorrection = 0
            offsetCorrection = translationY
        }
        if unclampedOffset <= -rootView.foldableView.bounds.height {
            // When topBarView is hidden
            // topBarViewOffsetY = translationY - offsetCorrection = -rootView.foldableView.bounds.height
            offsetCorrection = translationY + rootView.foldableView.bounds.height
        }
        let passedFoldableViewYOffset = foldableViewYOffset
        foldableViewYOffset = translationY - offsetCorrection
        rootView.updateFoldableViewYOffset(foldableViewYOffset)
        rootView.contentCollectionView.contentOffset.y += foldableViewYOffset - passedFoldableViewYOffset
        rootView.foldableView.alpha = 1 + foldableViewYOffset / rootView.foldableView.bounds.height
        
        // Magnetic snapping effect when the gesture ends
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self else { return }
                switch ScrollDirection(velocity: velocityY) {
                case .up:
                    foldableViewYOffset = .zero
                    rootView.updateFoldableViewYOffset(foldableViewYOffset)
                    offsetCorrection = .zero
                    rootView.foldableView.alpha = 1
                case .down:
                    foldableViewYOffset = -rootView.foldableView.bounds.height
                    rootView.updateFoldableViewYOffset(foldableViewYOffset)
                    offsetCorrection = rootView.foldableView.bounds.height
                    rootView.foldableView.alpha = .zero
                case nil:
                    break
                }
                rootView.layoutIfNeeded()
            })
        }
    }
    
    private func pushOttSelectViewController(_ action: UIAction) {
        guard let ottSelectViewController = viewControllerFactory?.makeOttSelectViewController(onboardingViewModel: onboardingViewModel) else { return }
        navigationController?.pushViewController(ottSelectViewController, animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension ContentSelectViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === rootView.selectedContentCollectionView {
            return selectedContentCollectionView(collectionView, numberOfItemsInSection: section)
        } else if collectionView === rootView.contentCollectionView {
            return contentCollectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === rootView.selectedContentCollectionView {
            return selectedContentCollectionView(collectionView, cellForItemAt: indexPath)
        } else if collectionView === rootView.contentCollectionView {
            return contentCollectionView(collectionView, cellForItemAt: indexPath)
        }
        return UICollectionViewCell()
    }
}

extension ContentSelectViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        contentCollectionView(collectionView, didSelectItemAt: indexPath)
    }
}

// MARK: - SelectedContentCollectionView DataSource

extension ContentSelectViewController {
    public func selectedContentCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingViewModel.selectedContents.value.count
    }
    
    public func selectedContentCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SelectedContentCollectionViewCell.self, for: indexPath)
        
        let content = onboardingViewModel.selectedContents.value[indexPath.item]
        
        cell.imageView.kf.setImage(with: content.posterUrl)
        cell.xButton.addAction(UIAction(handler: { [weak self] _ in
            self?.onboardingViewModel.deleteContent(content)
        }), for: .touchUpInside)
        return cell
    }
}

// MARK: - ContentCollectionView DataSource & Delegate

extension ContentSelectViewController {
    public func contentCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingViewModel.contents.value.count
    }
    
    public func contentCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(OnboardingContentCollectionViewCell.self, for: indexPath)
        
        let content = onboardingViewModel.contents.value[indexPath.item]
        let isSelected = onboardingViewModel.selectedContents.value.contains(where: {
            $0 == content
        })
        cell.configure(content: content, isSelected: isSelected)
        return cell
    }
}

extension ContentSelectViewController {
    public func contentCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard onboardingViewModel.selectedContents.value.count <= 6 else {
            return
        }
        onboardingViewModel.clickContent(onboardingViewModel.contents.value[indexPath.item])
    }
}

// MARK: - SearchTextField Delegate

extension ContentSelectViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return true }
        onboardingViewModel.searchContents(text)
        return true
    }
}
