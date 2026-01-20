//
//  SavedContentItem.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import Foundation

public struct RecentSavedContentItem: Hashable {
    public let id: UUID = UUID()
    public let posterImageName: String
    public let title: String
    public let year: Int
    
    public let availableOn: Set<CircleOTTPlatform>
    public let subscribedOn: Set<CircleOTTPlatform>
    
    public var eligiblePlatforms: [CircleOTTPlatform] {
        let eligible = availableOn.intersection(subscribedOn)
        return CircleOTTPlatform.order.filter { eligible.contains($0) }
    }
    
    public var logoDisplayModel: (leading: [CircleOTTPlatform], remainingCount: Int) {
        let list = eligiblePlatforms
        if list.count <= 2 {
            return(list, 0)
        }
        return (Array(list.prefix(2)), list.count - 2)
    }
    
    public init(posterImageName: String, title: String, year: Int, availableOn: Set<CircleOTTPlatform>, subscribedOn: Set<CircleOTTPlatform>) {
        self.posterImageName = posterImageName
        self.title = title
        self.year = year
        self.availableOn = availableOn
        self.subscribedOn = subscribedOn
    }
}
