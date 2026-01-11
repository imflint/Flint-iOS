
//
//  ExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit
import Then
import Combine

final class CollectionSectionView: BaseView {

    // MARK: - Public Event

    var onTapMore: (() -> Void)?
    var onSelectItem: ((UUID) -> Void)?

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.textColor = .flintGray100
        $0.text = "눈여겨보고 있는 컬렉션"
        $0.applyFontStyle(.head3_sb_18)
    }

    private let subtitleLabel = UILabel().then {
        $0.textColor = .flintGray400
        $0.text = "키키님이 최근 살펴본 컬렉션이에요"
    }

    private let moreButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage.icMore.withRenderingMode(.alwaysTemplate)
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        $0.configuration = config

        $0.tintColor = .flintGray300
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout()).then {
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
    private let chevronTapSubject = PassthroughSubject<Void, Never>()
    private let itemSelectSubject = PassthroughSubject<UUID, Never>()

    private var output: RecentCollectionSectionViewModel.Output?
    private var cancellables = Set<AnyCancellable>()

    private var items: [RecentCollectionItemViewData] = []

    // MARK: - Public API

    func bind(viewModel: RecentCollectionSectionViewModel) {
        cancellables.removeAll()

        let input = RecentCollectionSectionViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            chevronTap: chevronTapSubject.eraseToAnyPublisher(),
            itemSelect: itemSelectSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)
        self.output = output

        output.titleText
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: titleLabel)
            .store(in: &cancellables)

        output.subtitleText
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: subtitleLabel)
            .store(in: &cancellables)

        output.items
            .receive(on: RunLoop.main)
            .sink { [weak self] newItems in
                self?.items = newItems
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        output.chevronTap
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
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    // MARK: - BaseView

    override func setUI() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(moreButton)
        addSubview(collectionView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(36)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-8)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(210)
            $0.bottom.equalToSuperview()
        }
    }

    private func setAction() {
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }

    // MARK: - Action

    @objc private func didTapMore() {
        chevronTapSubject.send(())
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

extension CollectionSectionView: UICollectionViewDataSource {

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

extension CollectionSectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard items.indices.contains(indexPath.item) else { return }
        itemSelectSubject.send(items[indexPath.item].id)
    }
}
