//
//  ExploreViewController.swift
//  FLINT
//
//  Created by 소은 on 1/6/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

import Domain

import View
import ViewModel

public final class ExploreViewController: BaseViewController<ExploreView> {
    
    public let exploreViewModel: ExploreViewModel
    
    // MARK: - Component
    
    private let gradientBackgroundView = FixedGradientView().then {
        $0.colors = [DesignSystem.Color.gray600, DesignSystem.Color.gray700]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0.1, y: 0)
        $0.endPoint = .init(x: 0.5, y: 0.6)
    }
    
    // MARK: - Basic
    
    public init(exploreViewModel: ExploreViewModel, viewControllerFactory: ViewControllerFactory) {
        self.exploreViewModel = exploreViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(left: .logo))
        rootView.mainCollectionView.register(ExploreCollectionViewCell.self)
        rootView.mainCollectionView.register(ExploreEmptyCollectionViewCell.self)
        rootView.mainCollectionView.delegate = self
        rootView.mainCollectionView.dataSource = self
    }
    
    // MARK: - Setup
    
    public override func bind() {
        exploreViewModel.collections.sink { [weak self] collectionInfoEntities in
            Log.d(collectionInfoEntities)
            self?.rootView.mainCollectionView.reloadData()
        }
        .store(in: &cancellables)
    }
    
    public override func setBaseHierarchy() {
        view.addSubviews(gradientBackgroundView)
        super.setBaseHierarchy()
    }
    
    public override func setBaseLayout() {
        super.setBaseLayout()
        gradientBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ExploreViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exploreViewModel.collections.value.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == exploreViewModel.collections.value.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreEmptyCollectionViewCell.reuseIdentifier, for: indexPath) as? ExploreEmptyCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.reuseIdentifier, for: indexPath) as? ExploreCollectionViewCell else {
            return UICollectionViewCell()
        }
        let collection = exploreViewModel.collections.value[indexPath.item]
        cell.collectionImageView.kf.setImage(with: collection.imageUrl)
        cell.collectionTitleLabel.attributedText = .pretendard(.display2_m_28, text: collection.title)
        cell.collectionDescriptionLabel.attributedText = .pretendard(.body1_r_16, text: collection.description)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UIScrollViewDelegate

extension ExploreViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)) else { return }
        exploreViewModel.indexUpdated(indexPath.item)
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self else { return }
            if indexPath.item == exploreViewModel.collections.value.count {
                setNavigationBar(.init(left: .logo, backgroundStyle: .clear))
            } else {
                setNavigationBar(.init(left: .logo))
            }
        })
    }
}
