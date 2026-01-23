//
//  FilmSelectViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit

import Domain

import View
import ViewModel

// TODO: - shadow & select logic

public final class FilmSelectViewController: BaseViewController<FilmSelectView> {
    
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
        
        onboardingViewModel.fetchContents()
        
        rootView.searchTextField.searchAction = { [weak self] keyword in
            self?.onboardingViewModel.searchContents(keyword ?? "")
        }
        rootView.searchTextField.clearAction = { [weak self] in
            self?.onboardingViewModel.fetchContents()
        }
        
        rootView.progressLabel.attributedText = .pretendard(.caption1_m_12, text: "\(onboardingViewModel.selectedContents.value.count)/\(onboardingViewModel.filmSelectQuestions.count)")
        rootView.progressView.progress = Float(onboardingViewModel.selectedContents.value.count) / Float(onboardingViewModel.filmSelectQuestions.count)
        rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "\(onboardingViewModel.nickname.value) 님이 좋아하는 작품 7개를 골라주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        rootView.subtitleLabel.attributedText = .pretendard(.body2_r_14, text: onboardingViewModel.filmSelectQuestions[onboardingViewModel.selectedContents.value.count])
        rootView.filmPreviewCollectionView.dataSource = self
        rootView.filmCollectionView.dataSource = self
        rootView.filmCollectionView.delegate = self
        rootView.searchTextField.delegate = self
        
        rootView.layoutIfNeeded()
        rootView.filmCollectionView.contentOffset.y = -rootView.filmCollectionView.contentInset.top
        
        rootView.filmCollectionView.panGestureRecognizer.addTarget(self, action: #selector(filmCollectionViewPanGesture))
    }
    
    public override func bind() {
        onboardingViewModel.nickname.sink { [weak self] nickname in
            guard let self else { return }
            rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "\(onboardingViewModel.nickname.value) 님이 좋아하는 작품 7개를 골라주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        }
        .store(in: &cancellables)
        
        onboardingViewModel.contents.sink { [weak self] contents in
            self?.rootView.emptyView.isHidden = !contents.isEmpty
            self?.rootView.filmCollectionView.reloadData()
        }
        .store(in: &cancellables)
        
        onboardingViewModel.selectedContents.sink { [weak self] selectedContents in
            guard let self else { return }
            UIView.animate(withDuration: 0.2, animations: {
                self.rootView.filmPreviewCollectionView.isHidden = selectedContents.isEmpty
            })
            self.rootView.filmPreviewCollectionView.reloadData()
            self.rootView.filmCollectionView.reloadData()
            rootView.progressLabel.attributedText = .pretendard(.caption1_m_12, text: "\(selectedContents.count)/\(onboardingViewModel.filmSelectQuestions.count)")
            rootView.progressView.progress = Float(selectedContents.count) / Float(onboardingViewModel.filmSelectQuestions.count)
            rootView.subtitleLabel.attributedText = .pretendard(.body2_r_14, text: onboardingViewModel.filmSelectQuestions[min(selectedContents.count, onboardingViewModel.filmSelectQuestions.count-1)])
        }
        .store(in: &cancellables)
    }
    
    @objc public func filmCollectionViewPanGesture(_ sender: UIPanGestureRecognizer) {
        // Adjust the accumulated scroll translation
        // so that the foldableView responds immediately when the scroll direction changes
        let translationY = sender.translation(in: rootView.filmCollectionView).y
        let velocityY = sender.velocity(in: rootView.filmCollectionView).y
        
        Log.d(translationY)
        
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
        rootView.filmCollectionView.contentOffset.y += foldableViewYOffset - passedFoldableViewYOffset
        rootView.foldableView.alpha = 1 + foldableViewYOffset / rootView.foldableView.bounds.height
        
        // Magnetic snapping effect when the gesture ends
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self else { return }
                switch ScrollDirection(velocity: velocityY) {
                case .up:
                    foldableViewYOffset = 0
                    rootView.updateFoldableViewYOffset(foldableViewYOffset)
                    offsetCorrection = 0
                    rootView.foldableView.alpha = 1
                case .down:
                    foldableViewYOffset = -rootView.foldableView.bounds.height
                    rootView.updateFoldableViewYOffset(foldableViewYOffset)
                    offsetCorrection = rootView.foldableView.bounds.height
                    rootView.foldableView.alpha = 0
                case nil:
                    break
                }
                rootView.layoutIfNeeded()
            })
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension FilmSelectViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === rootView.filmPreviewCollectionView {
            return filmPreviewCollectionView(collectionView, numberOfItemsInSection: section)
        } else if collectionView === rootView.filmCollectionView {
            return filmCollectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === rootView.filmPreviewCollectionView {
            return filmPreviewCollectionView(collectionView, cellForItemAt: indexPath)
        } else if collectionView === rootView.filmCollectionView {
            return filmCollectionView(collectionView, cellForItemAt: indexPath)
        }
        return UICollectionViewCell()
    }
}

extension FilmSelectViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filmCollectionView(collectionView, didSelectItemAt: indexPath)
    }
}

// MARK: - FilmPreviewCollectionView DataSource

extension FilmSelectViewController {
    public func filmPreviewCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingViewModel.selectedContents.value.count
    }
    
    public func filmPreviewCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmPreviewCollectionViewCell.reuseIdentifier, for: indexPath) as? FilmPreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        let content = onboardingViewModel.selectedContents.value[indexPath.item]
        
        cell.imageView.kf.setImage(with: content.posterUrl)
        cell.xButton.addAction(UIAction(handler: { [weak self] _ in
            self?.onboardingViewModel.deleteContent(content)
        }), for: .touchUpInside)
        return cell
    }
}

// MARK: - FilmCollectionView DataSource & Delegate

extension FilmSelectViewController {
    public func filmCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingViewModel.contents.value.count
    }
    
    public func filmCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingFilmCollectionViewCell.reuseIdentifier, for: indexPath) as? OnboardingFilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        let content = onboardingViewModel.contents.value[indexPath.item]
        
        cell.overlayView.isHidden = !onboardingViewModel.selectedContents.value.contains(where: {
            $0 == content
        })
        cell.titleLabel.attributedText = .pretendard(.body1_r_16, text: content.title)
        cell.directorLabel.attributedText = .pretendard(.caption1_r_12, text: content.author)
        cell.yearLabel.attributedText = .pretendard(.caption1_r_12, text: "\(content.year)")
        cell.imageView.kf.setImage(with: content.posterUrl)
        return cell
    }
}

extension FilmSelectViewController {
    public func filmCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard onboardingViewModel.selectedContents.value.count <= 6 else {
            return
        }
        onboardingViewModel.clickContent(onboardingViewModel.contents.value[indexPath.item])
    }
}

extension FilmSelectViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return true }
        onboardingViewModel.searchContents(text)
        return true
    }
}
