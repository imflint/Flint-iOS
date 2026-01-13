//
//  SavedContentItem.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import Foundation

struct SavedContentItem: Hashable {
    let id: UUID = UUID()
    let posterImageName: String
    let title: String
    let year: Int
    
    let availableOn: Set<CircleOTTPlatform>
    let subscribedOn: Set<CircleOTTPlatform>
    
    var eligiblePlatforms: [CircleOTTPlatform] {
        let eligible = availableOn.intersection(subscribedOn)
        return CircleOTTPlatform.order.filter { eligible.contains($0) }
    }
    
    var logoDisplayModel: (leading: [CircleOTTPlatform], remainingCount: Int) {
        let list = eligiblePlatforms
        if list.count <= 2 {
            return(list, 0)
        }
        return (Array(list.prefix(2)), list.count - 2)
    }
}
