//
//  ConfirmModalType.swift
//  FLINT
//
//  Created by 소은 on 1/9/26.
//

import UIKit

// MARK: - ConfirmModalType

enum ConfirmModalType {
    case deleteWork

    var icon: UIImage? {
        switch self {
        case .deleteWork:
            return UIImage.icTrashGradient
        }
    }

    var title: String {
        switch self {
        case .deleteWork:
            return "작품을 삭제할까요?"
        }
    }

    var cancelTitle: String {
        switch self {
        case .deleteWork:
            return "취소"
        }
    }

    var confirmTitle: String {
        switch self {
        case .deleteWork:
            return "삭제"
        }
    }

    var confirmButtonColor: UIColor {
        switch self {
        case .deleteWork:
            return .flintError500
        }
    }
}
