//
//  EmptyState.swift
//  FLINT
//
//  Created by 소은 on 1/8/26.
//

import UIKit

// MARK: - EmptyStateType

enum EmptyStateType {
    case notFoundWork
    case anyFindWork

    var image: UIImage? {
        switch self {
        case .notFoundWork:
            return UIImage.icNoneGradient
        case .anyFindWork:
            return UIImage.icMagnifierGradient
        }
    }

    var title: String {
        switch self {
        case .notFoundWork:
            return "작품을 찾을 수 없어요"
        case .anyFindWork:
            return "떠오르는 작품이 있나요?"
        }
    }
}
