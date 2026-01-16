//
//  RecentCollectionTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

import UIKit

import SnapKit
import Then

final class MoreNoMoreCollectionTableViewCell: BaseTableViewCell {

    static let reuseIdentifier = "MoreNoMoreCollectionTableViewCell"

    var onSelectItem: ((MoreNoMoreCollectionItem) -> Void)?

    private var items: [MoreNoMoreCollectionItem] = []

    // MARK: - UI

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        $0.register(
            MoreNoMoreCollectionItemCell.self,
            forCellWithReuseIdentifier: MoreNoMoreCollectionItemCell.reuseIdentifier
        )
    }

    // MARK: - BaseTableViewCell

    override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    override func setHierarchy() {
        contentView.addSubview(collectionView)
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(260)
            $0.height.equalTo(180)
        }
    }

    override func prepare() {
        onSelectItem = nil
        items = []
        collectionView.reloadData()
    }

    // MARK: - Public

    func configure(items: [MoreNoMoreCollectionItem]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource / Delegate

extension MoreNoMoreCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoreNoMoreCollectionItemCell.reuseIdentifier,
            for: indexPath
        ) as? MoreNoMoreCollectionItemCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.item])
    }
}

// MARK: - Layout

private extension MoreNoMoreCollectionTableViewCell {

    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12

        layout.itemSize = CGSize(width: 260, height: 180)

        return layout
    }
}
