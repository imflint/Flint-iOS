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

public protocol ExploreViewControllerFactory {
    func makeExploreViewController() -> ExploreViewController
}

public final class ExploreViewController: BaseViewController<ExploreView> {
    
    public let exploreViewModel: ExploreViewModel
    
    private var mainCollectionViewDataSource: UICollectionViewDiffableDataSource<MainCollectionViewSection, MainCollectionViewItem>?
    
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
        setupMainCollectionView()
    }
    
    // MARK: - Setup
    
    public override func bind() {
        exploreViewModel.collections.sink { [weak self] exploreInfoEntities in
            guard let self else { return }
            mainCollectionViewDataSource?.apply(makeSnapshot(exploreInfoEntities: exploreInfoEntities, isCollectionsExhausted: exploreViewModel.cursor.value == nil), animatingDifferences: false)
        }
        .store(in: &cancellables)
        
        exploreViewModel.cursor.sink(receiveValue: { [weak self] cursor in
            guard let self else { return }
            mainCollectionViewDataSource?.apply(makeSnapshot(exploreInfoEntities: exploreViewModel.collections.value, isCollectionsExhausted: cursor == nil), animatingDifferences: false)
        })
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

// MARK: - MainCollectionView

extension ExploreViewController {
    private enum MainCollectionViewSection: Int {
        case main
        case empty
    }
    
    private enum MainCollectionViewItem: Hashable, Sendable {
        case collection(ExploreInfoEntity)
        case empty
    }
    
    private func setupMainCollectionView() {
        rootView.mainCollectionView.register(ExploreCollectionViewCell.self)
        rootView.mainCollectionView.register(ExploreEmptyCollectionViewCell.self)
        rootView.mainCollectionView.delegate = self
        rootView.mainCollectionView.dataSource = mainCollectionViewDataSource
        
        mainCollectionViewDataSource = UICollectionViewDiffableDataSource<MainCollectionViewSection, MainCollectionViewItem>(collectionView: rootView.mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            
            switch itemIdentifier {
            case let .collection(collection):
                let cell = collectionView.dequeueReusableCell(ExploreCollectionViewCell.self, for: indexPath)
                cell.collectionImageView.kf.setImage(with: collection.imageUrl)
                cell.collectionTitleLabel.attributedText = .pretendard(.display2_m_28, text: collection.title)
                cell.collectionDescriptionLabel.attributedText = .pretendard(.body1_r_16, text: collection.description)
                cell.collectionDetailButton.addAction(UIAction(handler: { [weak self] _ in
                    self?.pushCollectionDetailViewController(collectionId: collection.collectionId)
                }), for: .touchUpInside)
                return cell
                
            case .empty:
                let cell = collectionView.dequeueReusableCell(ExploreEmptyCollectionViewCell.self, for: indexPath)
                cell.createCollectionButton.addAction(UIAction(handler: pushCreateCollectionViewController(_:)), for: .touchUpInside)
                return cell
            }
        })
        mainCollectionViewDataSource?.apply(makeSnapshot(exploreInfoEntities: exploreViewModel.collections.value, isCollectionsExhausted: exploreViewModel.cursor.value == nil), animatingDifferences: false)
    }
    
    private func makeSnapshot(exploreInfoEntities: [ExploreInfoEntity], isCollectionsExhausted: Bool) -> NSDiffableDataSourceSnapshot<MainCollectionViewSection, MainCollectionViewItem> {
        var snapshot = NSDiffableDataSourceSnapshot<MainCollectionViewSection, MainCollectionViewItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(exploreInfoEntities.map({ MainCollectionViewItem.collection($0) }), toSection: .main)
        
        if isCollectionsExhausted {
            snapshot.appendSections([.empty])
            snapshot.appendItems([MainCollectionViewItem.empty], toSection: .empty)
        }
        return snapshot
    }
    
    private func pushCollectionDetailViewController(collectionId: Int64) {
        guard let vc = viewControllerFactory?.makeCollectionDetailViewController(collectionId: collectionId) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushCreateCollectionViewController(_ action: UIAction) {
        guard let vc = viewControllerFactory?.makeCreateCollectionViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ExploreViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)) else { return }
        exploreViewModel.indexUpdated(indexPath.item)
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self else { return }
            if indexPath.section == MainCollectionViewSection.empty.rawValue {
                setNavigationBar(.init(left: .logo, backgroundStyle: .clear))
            } else {
                setNavigationBar(.init(left: .logo))
            }
        })
    }
}
