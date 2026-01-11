//
//  ExampleTitleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class ExampleTitleViewController: UIViewController {

    // MARK: - UI

    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }

    private let headerView = TitleHeaderView()
    private let recentSectionView = RecentCollectionSectionView()

    // MARK: - Dependency

    private let recentViewModel: RecentCollectionSectionViewModel

    // MARK: - Init

    init(recentViewModel: RecentCollectionSectionViewModel) {
        self.recentViewModel = recentViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flintBackground

        setUI()
        bind()
    }

    // MARK: - Private

    private func setUI() {
        view.addSubview(contentStackView)

        contentStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        headerView.configure(
            title: "Fliner의 추천 컬렉션을 만나보세요",
            subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
        )

        contentStackView.addArrangedSubview(headerView)
        contentStackView.addArrangedSubview(recentSectionView)
    }

    private func bind() {
        recentSectionView.bind(viewModel: recentViewModel)
        recentSectionView.start()
    }
}
