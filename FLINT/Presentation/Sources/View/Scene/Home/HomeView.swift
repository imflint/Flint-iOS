//
//
//
//  HomeView.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import UIKit

import SnapKit
import Then

public final class HomeView: BaseView {
    
    // MARK: - UI
    
    public let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    public let flinerCollectionView: UICollectionView = {
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
    
    public let flinerPageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    public let floatingButton = UIButton(type: .custom).then {
        $0.setImage(DesignSystem.Image.Common.fab, for: .normal)
    }
    
    // MARK: - BaseView
    
    public override func setUI() {
        backgroundColor = .flintBackground
        addSubviews(tableView, floatingButton)
        bringSubviewToFront(floatingButton)
        bringSubviewToFront(flinerCollectionView)
        bringSubviewToFront(flinerPageControl)
        
        flinerCollectionView.isHidden = true
        flinerPageControl.isHidden = true
    }
    
    public override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(36)
            $0.size.equalTo(48)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        floatingButton.layer.applyShadow(
            color: .black,
            alpha: 0.3,
            blur: 16,
            spread: 0,
            x: 0,
            y: 0,
            cornerRadius: 24
        )
    }
}

