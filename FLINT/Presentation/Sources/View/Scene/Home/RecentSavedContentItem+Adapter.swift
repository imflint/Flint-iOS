//
//  RecentSavedContentItem+Adapter.swift
//  Presentation
//
//  Created by 소은 on 1/22/26.
//

// RecentSavedContentItem+Adapter.swift (View 모듈)

import ViewModel

public extension RecentSavedContentItem {
    init(viewData: RecentSavedContentViewData) {
        self.init(
            posterImageName: viewData.posterImageName,
            title: viewData.title,
            year: viewData.year,
            availableOn: Set(viewData.availableOn.map(CircleOTTPlatform.init(viewData:))),
            subscribedOn: Set(viewData.subscribedOn.map(CircleOTTPlatform.init(viewData:)))
        )
    }
}

public extension CircleOTTPlatform {
    init(viewData: OTTPlatformViewData) {
        switch viewData {
        case .netflix: self = .netflix
        case .disneyPlus: self = .disneyPlus
        case .watcha: self = .watcha
        case .wave: self = .wave
        case .tving: self = .tving
        }
    }
}
