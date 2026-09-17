//
//  AnalyticsUserProperty.swift
//  Presentation
//
//  Created by 진소은 on 9/17/26.
//

import Foundation

public enum AnalyticsUserProperty {

    case signupDate(Date)
    case lastLoginDate(Date)
    case userType(UserType)
    case keywordUpdated(Bool)
    case keywordUpdateCount(Int)

    public var name: String {
        switch self {
        case .signupDate: return "signup_date"
        case .lastLoginDate: return "last_login_date"
        case .userType: return "user_type"
        case .keywordUpdated: return "keyword_updated"
        case .keywordUpdateCount: return "keyword_update_count"
        }
    }

    public var value: Any {
        switch self {
        case let .signupDate(date), let .lastLoginDate(date):
            return Self.dateFormatter.string(from: date)
        case let .userType(type):
            return type.rawValue
        case let .keywordUpdated(flag):
            return flag
        case let .keywordUpdateCount(count):
            return count
        }
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "Asia/Seoul")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    public enum UserType: String {
        case user
        case fliner
    }
}
