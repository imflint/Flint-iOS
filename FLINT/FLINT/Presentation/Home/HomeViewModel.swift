//
//  HomeViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/18/26.
//

import Foundation
import UIKit

final class HomeViewModel {

    struct SectionModel {
        let rows: [Row]
    }

    enum Row {
        case greeting(userName: String)
        case header(style: TitleHeaderTableViewCell.HeaderStyle, title: String, subtitle: String)
        case fliner(items: [MoreNoMoreCollectionItem])
        case recentSaved(items: [RecentSavedContentItem])
        case ctaButton(title: String)
    }

    let sections: [SectionModel]

    init(userName: String) {

        let dummyFlinerItems: [MoreNoMoreCollectionItem] = [
            .init(id: UUID(),
                  image: UIImage(named: "img_background_gradiant_middle"),
                  profileImage: UIImage(named: "img_profile_blue"),
                  title: "사랑에 빠지기 10초 전",
                  userName: "사용자 이름"),
            .init(id: UUID(),
                  image: UIImage(named: "img_background_gradiant_middle"),
                  profileImage: UIImage(named: "img_profile_blue"),
                  title: "한번 보면 못 빠져나오는…",
                  userName: "사용자 이름"),
            .init(id: UUID(),
                  image: UIImage(named: "img_background_gradiant_middle"),
                  profileImage: UIImage(named: "img_profile_blue"),
                  title: "주말에 보기 좋은 영화",
                  userName: "사용자 이름")
        ]

        let dummyRecentSavedItems: [RecentSavedContentItem] = [
            .init(posterImageName: "img_background_gradiant_large",
                  title: "듄: 파트 2",
                  year: 2024,
                  availableOn: [.netflix, .disneyPlus, .watcha],
                  subscribedOn: [.netflix, .wave]),
            .init(posterImageName: "img_background_gradiant_large",
                  title: "오펜하이머",
                  year: 2023,
                  availableOn: [.wave, .tving, .netflix,.disneyPlus, .watcha],
                  subscribedOn: [.tving, .wave, .netflix,.disneyPlus, .watcha]),
            .init(posterImageName: "img_background_gradiant_large",
                  title: "스즈메의 문단속",
                  year: 2022,
                  availableOn: [.netflix, .watcha, .disneyPlus, .watcha],
                  subscribedOn: [.netflix,.disneyPlus, .watcha]),
            .init(posterImageName: "img_background_gradiant_large",
                  title: "스즈메의 문단속",
                  year: 2022,
                  availableOn: [.netflix, .watcha],
                  subscribedOn: [.netflix])
        ]

      
        let watchingCollectionItems: [MoreNoMoreCollectionItem] = [
            ///데이터가있는경우는 여기 .init을 채우면 나옵니다
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
                .recentSaved(items: dummyRecentSavedItems)
            ]),
            .init(rows: watchingSectionRows) 
        ]
    }
}
