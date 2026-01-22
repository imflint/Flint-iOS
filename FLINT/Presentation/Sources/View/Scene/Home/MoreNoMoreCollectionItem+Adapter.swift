//
//  MoreNoMoreCollectionItem+Adapter.swift
//  Presentation
//
//  Created by 소은 on 1/22/26.
//

// MoreNoMoreCollectionItem+Adapter.swift (View 모듈)

import ViewModel
import UIKit

public extension MoreNoMoreCollectionItem {
    init(_ item: FlinerCollectionViewData) {
        self.init(
            id: item.id,
            image: UIImage(named: item.imageName) ?? UIImage(),
            profileImage: UIImage(named: item.profileImageName) ?? UIImage(),
            title: item.title,
            userName: item.userName
        )
    }
}
