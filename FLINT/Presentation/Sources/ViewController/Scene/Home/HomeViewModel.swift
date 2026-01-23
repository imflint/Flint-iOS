//
//  HomeViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import Foundation
import Entity

public final class HomeViewModel {

    public struct SectionModel {
        public let rows: [Row]
    }

    public enum TitleHeaderStyle {
        case normal
        case more
    }

    public enum Row {
        case greeting(userName: String)
        case header(style: TitleHeaderStyle, title: String, subtitle: String)

        case fliner(items: [CollectionEntity])

        // ⚠️ RecentSavedContentItem이 어느 레이어 타입인지 불명확해서 유지
        // 가능하면 이것도 Entity로 바꾸는 게 방향상 맞음
//        case recentSaved(items: [RecentSavedContentItem])

        case ctaButton(title: String)
    }

    public let sections: [SectionModel]

    public init(userName: String) {

        // ✅ CollectionEntity 더미는 이제 "String / url / ..." 기반으로 생성해야 함
        let dummyFlinerItems: [CollectionEntity] = [
            .init(
                id: "1",
                thumbnailUrl: "https://example.com/thumbnail1.jpg",
                title: "사랑에 빠지기 10초 전",
                description: "",
                imageList: [],
                bookmarkCount: 0,
                isBookmarked: false,
                userId: "123",
                nickname: "사용자 이름",
                profileImageUrl: "https://example.com/profile.jpg"
            ),
            .init(
                id: "2",
                thumbnailUrl: "https://example.com/thumbnail2.jpg",
                title: "한번 보면 못 빠져나오는…",
                description: "",
                imageList: [],
                bookmarkCount: 0,
                isBookmarked: false,
                userId: "123",
                nickname: "사용자 이름",
                profileImageUrl: "https://example.com/profile.jpg"
            ),
            .init(
                id: "3",
                thumbnailUrl: "https://example.com/thumbnail3.jpg",
                title: "주말에 보기 좋은 영화",
                description: "",
                imageList: [],
                bookmarkCount: 0,
                isBookmarked: false,
                userId: "123",
                nickname: "사용자 이름",
                profileImageUrl: "https://example.com/profile.jpg"
            )
        ]

        // ⚠️ 이 타입이 어디 레이어인지 불명확(지금 코드만으로)
//        let dummyRecentSavedItems: [RecentSavedContentItem] = [
//            .init(posterImageName: "img_background_gradiant_large",
//                  title: "듄: 파트 2",
//                  year: 2024,
//                  availableOn: [.netflix, .disneyPlus, .watcha],
//                  subscribedOn: [.netflix, .wave])
//        ]

        // ✅ "눈여겨보는 컬렉션"도 CollectionEntity로
        let watchingCollectionItems: [CollectionEntity] = [
            .init(
                id: "10",
                thumbnailUrl: "https://example.com/thumbnail10.jpg",
                title: "요즘 빠진 스릴러만 모았어요",
                description: "",
                imageList: [],
                bookmarkCount: 0,
                isBookmarked: false,
                userId: "999",
                nickname: "키키",
                profileImageUrl: "https://example.com/profile2.jpg"
            )
        ]

        let watchingSectionRows: [Row]
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
            .init(rows: [
                .greeting(userName: userName)
            ]),
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
//                .recentSaved(items: dummyRecentSavedItems)
            ]),
            .init(rows: watchingSectionRows)
        ]
    }
}
