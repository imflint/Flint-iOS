//
//  MockRecentCollectionUseCase.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import UIKit

import Combine
import Foundation

final class RecentCollectionUseCase: RecentCollectionUseCaseProtocol {
    
    //MARK: - mock데이터
    
    func fetchRecentCollections() -> AnyPublisher<[RecentCollectionItemEntity], Error> {
        let data: [RecentCollectionItemEntity] = [
            .init(
                id: UUID(),
                title: "한번 보면 못 빠져나오는 사랑이야기",
                userName: "사용자 이름",
                imageName: "img_background_gradiant_large",
                imageURL: nil,
                profileImageName: "img_profile_gray",
                profileImageURL: nil
            ),
            .init(
                id: UUID(),
                title: "사랑에 빠지기 10초전",
                userName: "사용자 이름",
                imageName: "img_background_gradiant_large",
                imageURL: nil,
                profileImageName: "img_profile_gray",
                profileImageURL: nil
            ),
            .init(
                id: UUID(),
                title: "사랑에 빠지기 10초전",
                userName: "사용자 이름",
                imageName: "img_background_gradiant_large",
                imageURL: nil,
                profileImageName: "img_profile_gray",
                profileImageURL: nil
            )
        ]

        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
