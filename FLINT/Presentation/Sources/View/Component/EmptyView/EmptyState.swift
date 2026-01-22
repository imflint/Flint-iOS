//
//  EmptyState.swift
//  FLINT
//
//  Created by 소은 on 1/8/26.
//

import UIKit

// MARK: - EmptyStateType

public enum EmptyStateType {
    case notFoundWork
    case anyFindWork

    public var image: UIImage? {
        switch self {
        case .notFoundWork:
            return UIImage.icNoneGradient
        case .anyFindWork:
            return UIImage.icMagnifierGradient
        }
    }

    public var title: String {
        switch self {
        case .notFoundWork:
            return "아직 준비 중인 작품이에요"
        case .anyFindWork:
            return "떠오르는 작품이 있나요?"
        }
    }
}
