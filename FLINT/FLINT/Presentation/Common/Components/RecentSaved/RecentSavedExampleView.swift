//
//  RecentSavedExampleView.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class ExampleSavedContentViewController: UIViewController {
    
    private let listView = SavedContentHorizontalListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .flintBackground

        view.addSubview(listView)
        listView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(320)
        }

        let items: [SavedContentItem] = [
            .init(
                posterImageName: "poster",
                title: "드라마 제목이 아주 길어질 때 말줄임표 처리 확인용",
                year: 2021,
                availableOn: [.netflix],
                subscribedOn: [.netflix]
            ),
            .init(
                posterImageName: "poster",
                title: "드라마 제목",
                year: 2020,
                availableOn: [.netflix, .tving, .wave, .disneyPlus],
                subscribedOn: [.netflix, .wave, .tving, .coupangPlay]
            ),
            .init(
                posterImageName: "poster",
                title: "드라마 제목",
                year: 2019,
                availableOn: [.disneyPlus],
                subscribedOn: [.netflix]
            )
        ]

        listView.configure(items: items)
    }
}
