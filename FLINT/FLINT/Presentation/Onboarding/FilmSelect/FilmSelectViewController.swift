//
//  FilmSelectViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit

// TODO: - shadow & select logic

final class FilmSelectViewController: BaseViewController<FilmSelectView> {
    
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
    
    // MARK: - Property
    
    private var offsetCorrection: CGFloat = 0
    
    // MARK: - Basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(left: .back, backgroundStyle: .solid(.flintBackground)))
        view.bringSubviewToFront(navigationBarView)
        view.bringSubviewToFront(statusBarBackgroundView)
        rootView.progressLabel.attributedText = .pretendard(.caption1_m_12, text: "1/7")
        rootView.progressView.progress = 1/7
        rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "얀비 님이 좋아하는 작품 7개를 골라주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        rootView.subtitleLabel.attributedText = .pretendard(.body2_r_14, text: "이번 달 가장 재미있었던 작품은?")
        rootView.filmPreviewCollectionView.dataSource = self
        rootView.filmCollectionView.dataSource = self
        
        rootView.layoutIfNeeded()
        
        rootView.filmCollectionView.contentInset.top = rootView.titleView.bounds.height + rootView.searchView.bounds.height + rootView.filmPreviewCollectionView.bounds.height + 8
        rootView.filmCollectionView.contentOffset.y = -rootView.filmCollectionView.contentInset.top
        
        rootView.filmCollectionView.panGestureRecognizer.addTarget(self, action: #selector(filmCollectionViewPanGesture))
    }
    
    @objc func filmCollectionViewPanGesture(_ sender: UIPanGestureRecognizer) {
        // Adjust the accumulated scroll translation
        // so that the topBarView responds immediately when the scroll direction changes
        let translationY = sender.translation(in: rootView.filmCollectionView).y
        let velocityY = sender.velocity(in: rootView.filmCollectionView).y
        
        let unclampedOffset = translationY - offsetCorrection
        
        // Update offsetCorrection value
        if unclampedOffset >= 0 {
            // When topBarView is visible
            // topBarViewOffsetY = translationY - offsetCorrection = 0
            offsetCorrection = translationY
        }
        if unclampedOffset <= -rootView.titleView.bounds.height {
            // When topBarView is hidden
            // topBarViewOffsetY = translationY - offsetCorrection = -rootView.topBarView.bounds.height
            offsetCorrection = translationY + rootView.titleView.bounds.height
        }
        
        let topBarViewOffsetY = translationY - offsetCorrection
        rootView.updateTopBarViewYPosition(topBarViewOffsetY)
        rootView.titleView.alpha = 1 + topBarViewOffsetY / rootView.titleView.bounds.height
        
        // Magnetic snapping effect when the gesture ends
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self else { return }
                switch ScrollDirection(velocity: velocityY) {
                case .up:
//                    rootView.filmCollectionView.contentOffset.y = -rootView.filmCollectionView.contentInset.top + titleViewTopOffset
                    rootView.updateTopBarViewYPosition(0)
                    offsetCorrection = 0
                    rootView.titleView.alpha = 1
                case .down:
//                    rootView.filmCollectionView.contentOffset.y = -rootView.filmCollectionView.contentInset.top + rootView.titleView.bounds.height + titleViewTopOffset
                    rootView.updateTopBarViewYPosition(-rootView.titleView.bounds.height)
                    offsetCorrection = rootView.titleView.bounds.height
                    rootView.titleView.alpha = 0
                case nil:
                    break
                }
                rootView.layoutIfNeeded()
            })
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FilmSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === rootView.filmPreviewCollectionView {
            return filmPreviewCollectionView(collectionView, numberOfItemsInSection: section)
        } else if collectionView === rootView.filmCollectionView {
            return filmCollectionView(collectionView, numberOfItemsInSection: section)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === rootView.filmPreviewCollectionView {
            return filmPreviewCollectionView(collectionView, cellForItemAt: indexPath)
        } else if collectionView === rootView.filmCollectionView {
            return filmCollectionView(collectionView, cellForItemAt: indexPath)
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - FilmPreviewCollectionView DataSource

extension FilmSelectViewController {
    func filmPreviewCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func filmPreviewCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmPreviewCollectionViewCell.reuseIdentifier, for: indexPath) as? FilmPreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - FilmCollectionView DataSource

extension FilmSelectViewController {
    func filmCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func filmCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingFilmCollectionViewCell.reuseIdentifier, for: indexPath) as? OnboardingFilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.attributedText = .pretendard(.body1_r_16, text: "은하수를 여행하는 히치하이커를 위한 안내서")
        cell.directorLabel.attributedText = .pretendard(.caption1_r_12, text: "가스 제닝스")
        cell.yearLabel.attributedText = .pretendard(.caption1_r_12, text: "2005")
        return cell
    }
}
