//
//  HomeViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import Foundation
import Combine

import Domain

public final class HomeViewModel {

    public let sections: [HomeSectionViewData]

    public init(userName: String) {

        let dummyFlinerItems: [FlinerCollectionViewData] = [
            .init(
                id: UUID(),
                imageName: "backgroundGradientMiddle",
                profileImageName: "profileBlue",
                title: "사랑에 빠지기 10초 전",
                userName: "사용자 이름"
            )
        ]

        let dummyRecentSavedItems: [RecentSavedContentViewData] = [
            .init(
                id: UUID(),
                posterImageName: "img_background_gradiant_large",
                title: "듄: 파트 2",
                year: 2024,
                availableOn: [.netflix, .disneyPlus, .watcha],
                subscribedOn: [.netflix, .wave]
            )
        ]

        let watchingCollectionItems: [FlinerCollectionViewData] = []

        let watchingSectionRows: [HomeRowViewData]
        if watchingCollectionItems.isEmpty {
            watchingSectionRows = [
                .header(
                    style: .normal,
                    title: "아직 읽어본 컬렉션이 없어요",
                    subtitle: "천천히 둘러보며 끌리는 취향을 발견해보세요"
                ),
                .ctaButton(title: "취향발견하러가기")
            ]
        } else {
            watchingSectionRows = [
                .header(
                    style: .more,
                    title: "눈여겨보고 있는 컬렉션",
                    subtitle: "\(userName)님이 최근 살펴본 컬렉션이에요"
                ),
                .fliner(items: watchingCollectionItems)
            ]
        }

        sections = [
            .init(rows: [.greeting(userName: userName)]),
            .init(rows: [
                .header(
                    style: .normal,
                    title: "Fliner의 추천 컬렉션을 만나보세요",
                    subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
                ),
                .fliner(items: dummyFlinerItems)
            ]),
            .init(rows: [
                .header(
                    style: .normal,
                    title: "최근 저장한 콘텐츠",
                    subtitle: "현재 구독 중인 OTT에서 볼 수 있는 작품들이에요"
                ),
                .recentSaved(items: dummyRecentSavedItems)
            ]),
            .init(rows: watchingSectionRows)
        ]
    }
}
