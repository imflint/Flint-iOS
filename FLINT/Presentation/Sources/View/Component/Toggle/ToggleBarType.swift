//
//  ToggleBarType.swift
//  FLINT
//
//  Created by 소은 on 1/8/26.
//

import UIKit

// MARK: - ToggleBarType

public enum ToggleBarType {
    case primary

    public var onTrackColor: UIColor {
        UIColor.flintSecondary400
    }

    public var offTrackColor: UIColor {
        UIColor.flintGray200
    }

    public var knobColor: UIColor {
        UIColor.flintWhite
    }

    public var shadowColor: UIColor {
        UIColor.flintGray50
    }

    public var borderColor: UIColor {
        UIColor.clear
    }
}
