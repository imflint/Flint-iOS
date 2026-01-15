//
//  CollectionFolderExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class CollectionFolderExampleViewController: BaseViewController {

    private let cardView = CollectionFolderView()

    override func setUI() {
        view.backgroundColor = .flintBackground
    }

    override func setHierarchy() {
        view.addSubview(cardView)
    }

    override func setLayout() {
        cardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(259)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.configure(
            .init(
                firstPosterImage: .poster2,
                secondPosterImage: .poster2,
                profileImage: .imgProfileGray,
                name: "닉네임",
                title: "한번 보면 못 빠져나오는 사랑이야기",
                description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                isBookmarked: false,
                bookmarkedCountText: "123"
            )
        )

        cardView.onTapCard = {
            print("카드 탭")
        }

        cardView.onTapBookmark = { isBookmarked in
            print("북마크 상태: \(isBookmarked)")
        }
    }
}
