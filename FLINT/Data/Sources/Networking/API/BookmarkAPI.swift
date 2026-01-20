//
//  BookmarkAPI.swift
//  Data
//
//  Created by 소은 on 1/21/26.
//

import Foundation

import Domain

import Moya

enum BookmarkAPI {
    case toggleCollectionBookmark(_ collectionId: Int64)
}

extension BookmarkAPI: TargetType {

    var baseURL: URL {
        guard let baseURL = URL(string: "https://flint.r-e.kr") else {
            Log.f("Invalid BaseURL")
            fatalError("Invalid BaseURL")
        }
        return baseURL
    }

    var path: String {
        switch self {
        case .toggleCollectionBookmark(let collectionId):
            return "/api/v1/bookmarks/collections/\(collectionId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .toggleCollectionBookmark:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .toggleCollectionBookmark:
            return .requestPlain
        }
    }
}
