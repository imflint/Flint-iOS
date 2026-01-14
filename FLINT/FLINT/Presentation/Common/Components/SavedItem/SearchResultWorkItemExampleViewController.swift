//
//  SearchResultWorkItemExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class SearchResultWorkItemExampleViewController: BaseViewController {

    // MARK: - UI

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }

    private let contentView = UIView()

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private let version1View = SavedContentItemView()
    private let version2View = SavedContentItemView()
    private let version3View = SavedContentItemView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureExamples()
        bindActions()
    }

    // MARK: - BaseViewController

    override func setUI() {
        view.backgroundColor = .black

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(version1View)
        stackView.addArrangedSubview(version2View)
        stackView.addArrangedSubview(version3View)
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }

        [version1View, version3View, version2View].forEach {
            $0.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(152)
            }
        }
    }

    // MARK: - Configure

    private func configureExamples() {
        let dummyModelV1 = SavedContentItemView.ViewModel(
            posterImage: UIImage(named: "poster_1"),
            title: "은하수를 여행하는 히치하이커를 위한 안내서",
            director: "가스 제닝스",
            year: "2005",
            bookmarkCount: 123,
            leadingPlatforms: [.coupangPlay, .disneyPlus],
            remainingPlatformCount: 0
        )

        let dummyModelV2 = SavedContentItemView.ViewModel(
            posterImage: UIImage(named: "poster_1"),
            title: "은하수를 여행하는 히치하이커를 위한 안내서",
            director: "가스 제닝스",
            year: "2005"
        )

        let dummyModelV3 = SavedContentItemView.ViewModel(
            posterImage: UIImage(named: "poster_1"),
            title: "은하수를 여행하는 히치하이커를 위한 안내서",
            director: "가스 제닝스",
            year: "2005"
        )

        version1View.configure(model: dummyModelV1, mode: .ottShortcutBookmark)
        version2View.configure(model: dummyModelV2, mode: .selectable(isSelected: false))
        version3View.configure(model: dummyModelV3, mode: .plain)
    }

    private func bindActions() {
        version1View.onTapBookmark = { [weak self] in
            self?.toast("Bookmark")
        }
        version1View.onTapShortcut = { [weak self] in
            self?.toast("Shortcut")
        }

        version2View.onTapCheckbox = { [weak self] isSelected in
            self?.toast("Checkbox: \(isSelected)")
        }

    }

    // MARK: - Debug Helper

    private func toast(_ message: String) {
        print("[SearchResultWorkItemExample] \(message)")
    }
}
