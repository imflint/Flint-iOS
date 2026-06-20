//
//  Genre.swift
//  Domain
//
//  Created by 김호성 on 2026.05.13.
//

import Foundation

public enum Genre: String, CaseIterable, Sendable {
    case action = "ACTION"
    case romance = "ROMANCE"
    case sf = "SCIENCE_FICTION"
    case drama = "DRAMA"
    case comedy = "COMEDY"
    case horror = "HORROR"
    
    public var title: String {
        switch self {
        case .action:
            return "액션"
        case .romance:
            return "로맨스"
        case .sf:
            return "SF"
        case .drama:
            return "드라마"
        case .comedy:
            return "코미디"
        case .horror:
            return "호러"
        }
    }
}
