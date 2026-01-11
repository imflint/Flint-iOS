//
//  ExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import SnapKit

final class ExampleViewController: UIViewController {

    private let collectionSectionView = CollectionSectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flintBackground

        view.addSubview(collectionSectionView)
        collectionSectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        let viewModel = RecentCollectionSectionViewModel(useCase: RecentCollectionUseCase())
        collectionSectionView.bind(viewModel: viewModel)

        collectionSectionView.onTapMore = { [weak self] in
            // TODO: 전체 컬렉션 화면 push
            print("more tapped")
            self?.view.endEditing(true)
        }

        collectionSectionView.onSelectItem = { [weak self] id in
            // TODO: 상세 화면 push
            print("selected id:", id)
            self?.view.endEditing(true)
        }

        collectionSectionView.start()
    }
}
