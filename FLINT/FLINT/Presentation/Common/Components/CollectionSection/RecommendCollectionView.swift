
//
//  RecommendCollectionView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then
import Combine

final class RecommendCollectionView: BaseView {

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

    // MARK: - MVVM

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let moreTapSubject = PassthroughSubject<Void, Never>()
    private let itemSelectSubject = PassthroughSubject<UUID, Never>()

    private var cancellables = Set<AnyCancellable>()
    private var items: [RecentCollectionItemViewData] = []

    // MARK: - Public API

    func bind(viewModel: RecentCollectionSectionViewModel) {
        cancellables.removeAll()

        let input = RecentCollectionSectionViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            moreTap: moreTapSubject.eraseToAnyPublisher(),
            itemSelect: itemSelectSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.items
            .receive(on: RunLoop.main)
            .sink { [weak self] newItems in
                self?.items = newItems
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        output.moreTap
            .sink { [weak self] in
                self?.onTapMore?()
            }
            .store(in: &cancellables)

        output.itemSelect
            .sink { [weak self] id in
                self?.onSelectItem?(id)
            }
            .store(in: &cancellables)
    }

    func start() {
        viewDidLoadSubject.send(())
    }

    func setHeader(title: String, subtitle: String) {
        titleHeaderView.configure(style: .normal, title: title, subtitle: subtitle)
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
            self?.moreTapSubject.send(())
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

extension RecommendCollectionView: UICollectionViewDataSource {

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

extension RecommendCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard items.indices.contains(indexPath.item) else { return }
        itemSelectSubject.send(items[indexPath.item].id)
    }
}
