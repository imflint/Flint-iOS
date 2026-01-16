//
//  CollectionFolderExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class CollectionFolderExampleViewController: BaseViewController {

    // MARK: - Property

    private let data: [CollectionFolderCollectionViewCell.Configuration] = [
        .init(
            firstPosterImage: .poster2,
            secondPosterImage: .poster2,
            profileImage: .imgProfileGray,
            name: "닉네임",
            title: "한번 보면 못 빠져나오는 사랑이야기",
            description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
            isBookmarked: false,
            bookmarkedCountText: "123"
        ),
        .init(
            firstPosterImage: .poster2,
            secondPosterImage: .poster2,
            profileImage: .imgProfileGray,
            name: "닉네임",
            title: "한번 보면 못 빠져나오는 사랑이야기",
            description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
            isBookmarked: false,
            bookmarkedCountText: "123"
        ),
        .init(
            firstPosterImage: .poster2,
            secondPosterImage: .poster2,
            profileImage: .imgProfileGray,
            name: "닉네임",
            title: "한번 보면 못 빠져나오는 사랑이야기",
            description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
            isBookmarked: false,
            bookmarkedCountText: "123"
        ),
        .init(
            firstPosterImage: .poster2,
            secondPosterImage: .poster2,
            profileImage: .imgProfileGray,
            name: "닉네임",
            title: "한번 보면 못 빠져나오는 사랑이야기",
            description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
            isBookmarked: false,
            bookmarkedCountText: "123"
        )
    ]

    // MARK: - UI Component

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            CollectionFolderCollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionFolderCollectionViewCell.reuseIdentifier
        )
    }

    // MARK: - Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Override

    override func setUI() {
        view.backgroundColor = .gray
    }

    override func setHierarchy() {
        view.addSubview(collectionView)
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: - Setup

    // MARK: - Action
    
    // MARK: - Custom Method
    private func makeLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 12
        let inset: CGFloat = 20
        let itemHeight: CGFloat = 259

        return UICollectionViewCompositionalLayout { _, env in
            let containerWidth = env.container.effectiveContentSize.width
            let contentWidth = containerWidth - (inset * 2) - spacing

            let leftWidth = floor(contentWidth / 2)
            let rightWidth = contentWidth - leftWidth

            let leftItemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(leftWidth),
                heightDimension: .absolute(itemHeight)
            )
            let rightItemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(rightWidth),
                heightDimension: .absolute(itemHeight)
            )

            let leftItem = NSCollectionLayoutItem(layoutSize: leftItemSize)
            let rightItem = NSCollectionLayoutItem(layoutSize: rightItemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftItem, rightItem])
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: inset, bottom: 24, trailing: inset)

            return section
        }
    }

    // MARK: - Configure

    // MARK: - Extension
}

// MARK: - Extension

extension CollectionFolderExampleViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionFolderCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? CollectionFolderCollectionViewCell
        else { return UICollectionViewCell() }

        let config = data[indexPath.item]
        cell.configure(config)

        cell.onTapCard = {
            print("카드 탭 - index: \(indexPath.item)")
        }

        cell.onTapBookmark = { isBookmarked in
            print("북마크 상태: \(isBookmarked) - index: \(indexPath.item)")
        }

        return cell
    }
}

extension CollectionFolderExampleViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt - index: \(indexPath.item)")
    }
}
