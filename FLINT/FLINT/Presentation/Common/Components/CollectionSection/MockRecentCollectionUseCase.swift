//
//  MockRecentCollectionUseCase.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import Combine
import Foundation

final class MockRecentCollectionUseCase: RecentCollectionUseCaseProtocol {

    func fetchRecentCollections() -> AnyPublisher<[RecentCollectionEntity], Error> {
        let data: [RecentCollectionEntity] = [
            .init(
                id: UUID(),
                title: "한번 보면 못 빠져나오는 사랑이야기",
                userName: "사용자 이름",
                imageName: "sample_collection_1",
                profileImageName: "img_profile_gray"
            ),
            .init(
                id: UUID(),
                title: "사랑에 빠지기 10초전",
                userName: "사용자 이름",
                imageName: "sample_collection_1",
                profileImageName: "img_profile_gray"
            ),
            .init(
                id: UUID(),
                title: "컬렉션제목",
                userName: "사용자 이름",
                imageName: "sample_collection_1",
                profileImageName: "img_profile_gray"
            )
        ]

        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
