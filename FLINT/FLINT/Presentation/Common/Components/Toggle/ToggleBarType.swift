//
//  ToggleBarType.swift
//  FLINT
//
//  Created by 소은 on 1/8/26.
//

import UIKit

// MARK: - ToggleBarType

enum ToggleBarType {
    case primary

    var onTrackColor: UIColor {
        UIColor.flintSecondary400
    }

    var offTrackColor: UIColor {
        UIColor.flintGray200
    }

    var knobColor: UIColor {
        UIColor.flintWhite
    }

    var shadowColor: UIColor {
        UIColor.flintGray50
    }

    var borderColor: UIColor {
        UIColor.clear
    }
}
