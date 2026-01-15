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

final class ExploreViewController: BaseViewController {
    
    private let rootView = ExploreView()
    
    // MARK: - Basic
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.mainCollectionView.register(ExploreCollectionViewCell.self)
        rootView.mainCollectionView.delegate = self
        rootView.mainCollectionView.dataSource = self
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - Logic 연결할 것!!
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.reuseIdentifier, for: indexPath) as? ExploreCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.collectionImageView.kf.setImage(with: URL(string: "https://d1al7qj7ydfbpt.cloudfront.net/artist/jypark/451c367c76d0456980228859e600c50e-231103+6PM+박진영+프로필+사진20231106082716152.jpg")!)
        return cell
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
