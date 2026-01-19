//
//  PreferenceExampleView.swift
//  FLINT
//
//  Created by 진소은 on 1/18/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

public final class PreferenceExampleView: BaseView {

    private let rankedView = PreferenceRankedChipView()

    public override func setHierarchy() {
        addSubview(rankedView)
    }

    public override func setLayout() {
        backgroundColor = .flintGray500

        rankedView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        let dummyData: [KeywordDTO] = [
            .init(color: .blue, rank: 1, name: "영화", percentage: 0, imageUrl: "https://picsum.photos/seed/1/80"),
            .init(color: .pink, rank: 2, name: "SF",   percentage: 0, imageUrl: "https://picsum.photos/seed/2/80"),
            .init(color: .green, rank: 3, name: "로맨스", percentage: 0, imageUrl: "https://picsum.photos/seed/3/80"),
            .init(color: .orange, rank: 4, name: "공포", percentage: 0, imageUrl: "https://picsum.photos/seed/4/80"),
            .init(color: .yellow, rank: 5, name: "액션", percentage: 0, imageUrl: "https://picsum.photos/seed/5/80"),
            .init(color: .pink, rank: 6, name: "성장", percentage: 0, imageUrl: "https://picsum.photos/seed/6/80"),
        ]

        rankedView.configure(keywords: dummyData)
    }
}
