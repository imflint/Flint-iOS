//
//  RecentCollectionMapper.swift
//  FLINT
//
//  Created by 소은 on 1/11/26.
//

import Foundation

// MARK: - DTO -> Entity

extension RecentCollectionResponseDTO {

    func toEntities() -> [RecentCollectionItemEntity] {
        items.compactMap { $0.toEntity() }
    }
}

extension RecentCollectionItemDTO {

    func toEntity() -> RecentCollectionItemEntity? {
        guard let uuid = UUID(uuidString: id) else { return nil }

        return RecentCollectionItemEntity(
            id: uuid,
            title: title,
            userName: userName,
            imageName: nil,
            imageURL: imageUrl.flatMap { URL(string: $0) },
            profileImageName: nil,
            profileImageURL: profileImageUrl.flatMap { URL(string: $0) }
        )
    }
}
