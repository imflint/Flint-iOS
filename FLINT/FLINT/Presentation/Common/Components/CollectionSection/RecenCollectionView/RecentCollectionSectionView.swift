
//
//  CollectionSectionView.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class RecentCollectionSectionView: BaseView {

    // MARK: - Public Event

    var onTapMore: (() -> Void)?
    var onSelectItem: ((UUID) -> Void)?

    // MARK: - UI

    private let titleHeaderView = TitleHeaderView()

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self

        $0.register(
            RecentCollectionCell.self,
            forCellWithReuseIdentifier: RecentCollectionCell.reuseIdentifier
        )
    }

    // MARK: - Data

    private var items: [RecentCollectionItem] = []

    func setHeader(title: String, subtitle: String) {
        titleHeaderView.configure(style: .more, title: title, subtitle: subtitle)
    }

    func update(items: [RecentCollectionItem]) {
        self.items = items
        collectionView.reloadData()
    }

    // MARK: - BaseView

    override func setUI() {
        addSubview(titleHeaderView)
        addSubview(collectionView)

        setAction()
    }

    override func setLayout() {
        titleHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleHeaderView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(210)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Action

    private func setAction() {
        titleHeaderView.onTapMore = { [weak self] in
            self?.onTapMore?()
        }
    }

    // MARK: - Layout

    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(260),
            heightDimension: .absolute(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(260),
            heightDimension: .absolute(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource

extension RecentCollectionSectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecentCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? RecentCollectionCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension RecentCollectionSectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard items.indices.contains(indexPath.item) else { return }
        onSelectItem?(items[indexPath.item].id)
    }
}
