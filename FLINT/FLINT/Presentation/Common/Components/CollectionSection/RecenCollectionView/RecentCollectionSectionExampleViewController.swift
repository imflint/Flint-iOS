//
//  RecentCollectionSectionExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/14/26.
//

import UIKit

import SnapKit

final class RecentCollectionSectionExampleViewController: BaseViewController {

    // MARK: - UI

    private let recentSectionView = RecentCollectionSectionView()

    // MARK: - LifeCycle

    override func setUI() {
        view.backgroundColor = .flintBackground
        view.addSubview(recentSectionView)

        bind()
        configureDummy()
    }

    override func setLayout() {
        recentSectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }
    }

    // MARK: - Bind

    private func bind() {
        recentSectionView.onTapMore = { [weak self] in
            guard let self else { return }
            print("✅ onTapMore")
        }

        recentSectionView.onSelectItem = { [weak self] id in
            guard let self else { return }
            print("✅ onSelectItem: \(id)")
        }
    }

    // MARK: - Dummy

    private func configureDummy() {
        let items: [RecentCollectionItem] = makeDummyItems()

        recentSectionView.configure(
            .default(
                headerStyle: .normal,
                title: "눈여겨보고 있는 컬렉션",
                subtitle: "키키님이 최근 살펴본 컬렉션이에요",
                items: items
            )
        )
    }

    private func makeDummyItems() -> [RecentCollectionItem] {
        return (0..<10).map { index in
            RecentCollectionItem(
                id: UUID(),
                image: UIImage(named: "img_background_gradiant_middle"),
                title: "비 오는 날 보기 좋은 영화",
                userName: "키키",
                profileImage: UIImage(named: "img_profile_blue")
            )
        }
    }
}
