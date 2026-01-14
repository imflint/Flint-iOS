//
//  MoreCollectionView.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit
import Then

final class MoreCollectionView: BaseView {

    // MARK: - Public Event

    var onTapMore: (() -> Void)?
    var onSelectItem: ((UUID) -> Void)?

    // MARK: - UI

    private let titleHeaderView = TitleHeaderView()

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(section: makeSectionLayout())
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

    // MARK: - State

    private var configuration: Configuration?
    private var items: [RecentCollectionItem] = []


    // MARK: - override

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
            $0.top.equalTo(titleHeaderView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Configure

    func configure(title: String, subtitle: String, items: [RecentCollectionItem]) {
        let configuration = Configuration(title: title, subtitle: subtitle, items: items)
        configure(configuration)
    }

    func configure(_ configuration: Configuration) {
        self.configuration = configuration

        titleHeaderView.configure(
            style: .more,
            title: configuration.title,
            subtitle: configuration.subtitle
        )

        items = configuration.items

        collectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout(section: makeSectionLayout()),
            animated: false
        )

        collectionView.reloadData()
    }
    // MARK: - Action

    private func setAction() {
        titleHeaderView.onTapMore = { [weak self] in
            self?.onTapMore?()
        }
    }

    // MARK: - Layout

    private func makeSectionLayout() -> NSCollectionLayoutSection {
        let config = configuration

        let itemSizeValue = config?.itemSize ?? CGSize(width: 260, height: 180)
        let sectionInset = config?.sectionInset ?? .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        let interGroupSpacing = config?.interGroupSpacing ?? 12

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemSizeValue.width),
            heightDimension: .absolute(itemSizeValue.height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemSizeValue.width),
            heightDimension: .absolute(itemSizeValue.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionInset
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}

// MARK: - Configuration

extension MoreCollectionView {

    struct Configuration: Equatable {
        let title: String
        let subtitle: String
        let items: [RecentCollectionItem]
        let sectionInset: NSDirectionalEdgeInsets
        let interGroupSpacing: CGFloat
        let itemSize: CGSize

        init(
            title: String,
            subtitle: String,
            items: [RecentCollectionItem],
            sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16),
            interGroupSpacing: CGFloat = 12,
            itemSize: CGSize = .init(width: 260, height: 180)
        ) {
            self.title = title
            self.subtitle = subtitle
            self.items = items
            self.sectionInset = sectionInset
            self.interGroupSpacing = interGroupSpacing
            self.itemSize = itemSize
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MoreCollectionView: UICollectionViewDataSource {

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

extension MoreCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard items.indices.contains(indexPath.item) else { return }
        onSelectItem?(items[indexPath.item].id)
    }
}
