//
//  HomeViewData.swift
//  Presentation
//
//  Created by 소은 on 1/22/26.
//

// HomeViewData.swift (ViewModel 모듈)

import Foundation

public struct HomeSectionViewData {
    public let rows: [HomeRowViewData]
}

public enum HomeRowViewData {
    case greeting(userName: String)
    case header(style: HomeHeaderStyle, title: String, subtitle: String)
    case fliner(items: [FlinerCollectionViewData])
    case recentSaved(items: [RecentSavedContentViewData])
    case ctaButton(title: String)
}

public enum HomeHeaderStyle {
    case normal
    case more
}

public struct FlinerCollectionViewData: Identifiable, Hashable {
    public let id: UUID
    public let imageName: String
    public let profileImageName: String
    public let title: String
    public let userName: String
}

public struct RecentSavedContentViewData: Identifiable, Hashable {
    public let id: UUID
    public let posterImageName: String
    public let title: String
    public let year: Int
    public let availableOn: [OTTPlatformViewData]
    public let subscribedOn: [OTTPlatformViewData]
}

public enum OTTPlatformViewData: String, CaseIterable, Hashable {
    case netflix
    case disneyPlus
    case watcha
    case wave
    case tving
}
