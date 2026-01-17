//
//  FilmSelectViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

// TODO: - shadow & select logic
class FilmSelectViewController: BaseViewController<FilmSelectView> {
    
    // MARK: - Basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(left: .back, backgroundStyle: .solid(.flintBackground)))
        rootView.progressLabel.attributedText = .pretendard(.caption1_m_12, text: "1/7")
        rootView.progressView.progress = 1/7
        rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "얀비 님이 좋아하는 작품 7개를 골라주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        rootView.subtitleLabel.attributedText = .pretendard(.body2_r_14, text: "이번 달 가장 재미있었던 작품은?")
        rootView.filmPreviewCollectionView.dataSource = self
        rootView.filmCollectionView.dataSource = self
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
        return cell
    }
}
