//
//  FlinerRecommendTableViewCell.swift
//  Presentation
//
//  Created by 소은 on 4/28/26.
//

import UIKit
import SnapKit
import Then
import Domain

// MARK: - Model

struct FlinerCardItem {
    let id: String
    let thumbnailUrl: URL?
    let curatorNickname: String
    let curatorProfileUrl: URL?
    let title: String
    let description: String
}

extension FlinerCardItem {
    init(entity: CollectionEntity) {
        self.id = entity.id
        self.thumbnailUrl = entity.thumbnailUrl
        self.curatorNickname = entity.user.nickname
        self.curatorProfileUrl = entity.user.profileImageUrl
        self.title = entity.title
        self.description = entity.description
    }
}

// MARK: - Cell

public final class FlinerRecommendTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    public var onSelectItem: ((String) -> Void)?
    
    private var items: [FlinerCardItem] = []
    private var infiniteItems: [FlinerCardItem] = []
    private let repeatCount = 3
    private var itemWidth: CGFloat = 0
    
    // MARK: - UI
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        cv.clipsToBounds = false
        return cv
    }()
    
    private let pageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(collectionView, pageControl)
    }
    
    public override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(400)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            FlinerRecommendCardCell.self,
            forCellWithReuseIdentifier: String(describing: FlinerRecommendCardCell.self)
        )
        
        pageControl.currentPageIndicatorTintColor = .flintSecondary400
        pageControl.pageIndicatorTintColor = .flintGray500
    }
    
    // MARK: - Configure
    
    public func configure(items: [CollectionEntity]) {
        let limited = Array(items.prefix(5))
        self.items = limited.map { FlinerCardItem(entity: $0) }
        self.infiniteItems = Array(repeating: self.items, count: repeatCount).flatMap { $0 }
        
        pageControl.numberOfPages = self.items.count
        pageControl.currentPage = 0
        
        collectionView.reloadData()
        
        // 중간 세트로 시작
        DispatchQueue.main.async {
            self.scrollToMiddle(animated: false)
        }
    }
    
    public override func prepare() {
        items = []
        infiniteItems = []
        pageControl.numberOfPages = 0
        collectionView.reloadData()
    }
    
    // MARK: - Private
    
    private func scrollToMiddle(animated: Bool) {
        guard !items.isEmpty else { return }
        let middleIndex = items.count * (repeatCount / 2)
        let inset = (collectionView.bounds.width - collectionView.bounds.width * 0.82) / 2
        let offsetX = CGFloat(middleIndex) * (itemWidth + 12) - inset
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
    
    private func currentRealIndex() -> Int {
        guard itemWidth > 0, !items.isEmpty else { return 0 }
        let index = Int(round(collectionView.contentOffset.x / (itemWidth + 12)))
        return index % items.count
    }
}

// MARK: - UICollectionViewDataSource

extension FlinerRecommendTableViewCell: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        infiniteItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FlinerRecommendCardCell.self),
            for: indexPath
        ) as! FlinerRecommendCardCell
        cell.configure(item: infiniteItems[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FlinerRecommendTableViewCell: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let realIndex = indexPath.item % items.count
        onSelectItem?(items[realIndex].id)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard itemWidth > 0, !items.isEmpty else { return }
        let inset = (collectionView.bounds.width - itemWidth) / 2
        let index = Int(round((scrollView.contentOffset.x + inset) / (itemWidth + 12)))
        pageControl.currentPage = index % items.count
    }
    
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard itemWidth > 0 else { return }
        let inset = (collectionView.bounds.width - itemWidth) / 2
        let itemStep = itemWidth + 12
        let targetIndex = round((targetContentOffset.pointee.x + inset) / itemStep)
        targetContentOffset.pointee.x = targetIndex * itemStep - inset
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        rebalanceIfNeeded()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        rebalanceIfNeeded()
    }
    
    private func rebalanceIfNeeded() {
        guard !items.isEmpty, itemWidth > 0 else { return }
        let itemStep = itemWidth + 12
        let inset = (collectionView.bounds.width - itemWidth) / 2
        let currentIndex = Int(round(collectionView.contentOffset.x / itemStep))
        let middleStart = items.count * (repeatCount / 2)
        
        if currentIndex < items.count || currentIndex >= items.count * (repeatCount - 1) {
            let realIndex = currentIndex % items.count
            let newIndex = middleStart + realIndex
            collectionView.setContentOffset(
                CGPoint(x: CGFloat(newIndex) * itemStep, y: 0),
                animated: false
            )
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = (collectionView.bounds.width - itemWidth) / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FlinerRecommendTableViewCell: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemWidth = collectionView.bounds.width * 0.82
        return CGSize(width: itemWidth, height: 400)
    }
}

