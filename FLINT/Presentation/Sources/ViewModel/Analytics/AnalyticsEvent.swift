//
//  AnalyticsEvent.swift
//  Presentation
//
//  Created by 진소은 on 9/17/26.
//

import Foundation

public enum AnalyticsEvent {

    case clickSignup
    case completeLogin

    case viewTos
    case viewFilmselect
    case viewNickname
    case viewOnboardingDone
    case completeOnboarding(durationSec: Int)
    case completeSignup

    case viewHome
    case clickHomeContent(contentType: HomeContentType)

    case clickBottomNavigation(tabName: BottomTab)

    case viewCollection(collectionId: Int64, source: CollectionSource)
    case saveContent(contentId: Int64)
    case saveCollection(collectionId: Int64)
    case viewCreateCollection
    case completeCreateCollection(collectionId: Int64)

    case viewExplore
    case viewExploreContent(contentId: Int64)
    case clickExploreCollection(collectionId: Int64)
    case exitExplore(durationSec: Int)

    case updateKeyword

    case viewSavedContent(contentId: Int64)

    public var name: String {
        switch self {
        case .clickSignup: return "click_signup"
        case .completeLogin: return "complete_login"
        case .viewTos: return "view_tos"
        case .viewFilmselect: return "view_filmselect"
        case .viewNickname: return "view_nickname"
        case .viewOnboardingDone: return "view_onboarding_done"
        case .completeOnboarding: return "complete_onboarding"
        case .completeSignup: return "complete_signup"
        case .viewHome: return "view_home"
        case .clickHomeContent: return "click_home_content"
        case .clickBottomNavigation: return "click_bottom_navigation"
        case .viewCollection: return "view_collection"
        case .saveContent: return "save_content"
        case .saveCollection: return "save_collection"
        case .viewCreateCollection: return "view_create_collection"
        case .completeCreateCollection: return "complete_create_collection"
        case .viewExplore: return "view_explore"
        case .viewExploreContent: return "view_explore_content"
        case .clickExploreCollection: return "click_explore_collection"
        case .exitExplore: return "exit_explore"
        case .updateKeyword: return "update_keyword"
        case .viewSavedContent: return "view_saved_content"
        }
    }

    public var properties: [String: Any]? {
        switch self {
        case let .completeOnboarding(durationSec):
            return ["duration_sec": durationSec]
        case let .clickHomeContent(contentType):
            return ["content_type": contentType.rawValue]
        case let .clickBottomNavigation(tabName):
            return ["tab_name": tabName.rawValue]
        case let .viewCollection(collectionId, source):
            return ["collection_id": collectionId, "source": source.rawValue]
        case let .saveContent(contentId):
            return ["content_id": contentId]
        case let .saveCollection(collectionId):
            return ["collection_id": collectionId]
        case let .completeCreateCollection(collectionId):
            return ["collection_id": collectionId]
        case let .viewExploreContent(contentId):
            return ["content_id": contentId]
        case let .clickExploreCollection(collectionId):
            return ["collection_id": collectionId]
        case let .exitExplore(durationSec):
            return ["duration_sec": durationSec]
        case let .viewSavedContent(contentId):
            return ["content_id": contentId]
        default:
            return nil
        }
    }
}

extension AnalyticsEvent {

    public enum HomeContentType: String {
        case fliner
        case recentlySaved = "recently_saved"
        case popular
    }

    public enum BottomTab: String {
        case home
        case explore
        case my
    }

    public enum CollectionSource: String {
        case homeFlinner = "home_flinner"
        case homePopular = "home_popular"
        case explore
        case mySaved = "my_saved"
        case myCreated = "my_created"
    }
}
