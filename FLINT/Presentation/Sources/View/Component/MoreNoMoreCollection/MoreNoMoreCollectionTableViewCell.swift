//
//  RecentCollectionTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/16/26.
//

import UIKit

import SnapKit
import Then

public final class MoreNoMoreCollectionTableViewCell: BaseTableViewCell {

    // ✅ 선택 이벤트도 “셀”이 아니라 “아이템”을 넘김
    public var onSelectItem: ((MoreNoMoreCollectionItem) -> Void)?

    // ✅ 셀 배열이 아니라 “모델 배열”
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

    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    public override func setHierarchy() {
        contentView.addSubview(collectionView)
    }

    public override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func prepare() {
        onSelectItem = nil
        items = []
        collectionView.reloadData()
    }

    // MARK: - Public

    // ✅ 이제 모델 배열을 받음
    public func configure(items: [MoreNoMoreCollectionItem]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension MoreNoMoreCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoreNoMoreCollectionItemCell.reuseIdentifier,
            for: indexPath
        ) as? MoreNoMoreCollectionItemCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: items[indexPath.item]) // ✅ 모델로 configure
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.item]) // ✅ 모델 전달
    }
}

private extension MoreNoMoreCollectionTableViewCell {
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 260, height: 180)
        return layout
    }
}
