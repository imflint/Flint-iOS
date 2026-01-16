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

final class ExploreViewController: BaseViewController<ExploreView> {
    
    // MARK: - Component
    
    private let statusBarBackgroundView = UIView().then {
        $0.backgroundColor = .flintBackground
    }
    
    private let gradientBackgroundView = FixedGradientView().then {
        $0.colors = [.flintGray600, .flintGray700]
        $0.locations = [0, 1]
        $0.startPoint = .init(x: 0.1, y: 0)
        $0.endPoint = .init(x: 0.5, y: 0.6)
    }
    
    // MARK: - Basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView.apply(.init(left: .logo))
        rootView.mainCollectionView.register(ExploreCollectionViewCell.self)
        rootView.mainCollectionView.register(ExploreEmptyCollectionViewCell.self)
        rootView.mainCollectionView.delegate = self
        rootView.mainCollectionView.dataSource = self
    }
    
    // MARK: - Setup
    
    override func setHierarchy() {
        view.addSubviews(gradientBackgroundView, statusBarBackgroundView)
        super.setHierarchy()
    }
    
    override func setLayout() {
        super.setLayout()
        gradientBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(navigationBarView.snp.top)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - Logic 연결할 것!!
        return 3 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 3 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreEmptyCollectionViewCell.reuseIdentifier, for: indexPath) as? ExploreEmptyCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.reuseIdentifier, for: indexPath) as? ExploreCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.collectionImageView.kf.setImage(with: URL(string: "https://d1al7qj7ydfbpt.cloudfront.net/artist/jypark/451c367c76d0456980228859e600c50e-231103+6PM+박진영+프로필+사진20231106082716152.jpg")!)
        cell.collectionTitleLabel.attributedText = .pretendard(.display2_m_28, text: "너의 모든 것")
        cell.collectionDescriptionLabel.attributedText = .pretendard(.body1_r_16, text: "뉴욕의 서점 매니저이자 반듯한 독서가, 조. \n그가 대학원생 벡을 만나 한눈에 반한다.\n하지만 훈훈했던 그의 첫인상은 잠시일 뿐,\n감추어진 조의 뒤틀린 이면이 드러난다.")
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UIScrollViewDelegate

extension ExploreViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)) else { return }
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if indexPath.row == 3 {
                self?.navigationBarView.apply(.init(left: .logo, backgroundStyle: .clear))
                self?.statusBarBackgroundView.backgroundColor = .clear
            } else {
                self?.navigationBarView.apply(.init(left: .logo))
                self?.statusBarBackgroundView.backgroundColor = .flintBackground
            }
        })
    }
}
