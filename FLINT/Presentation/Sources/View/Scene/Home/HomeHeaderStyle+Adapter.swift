//
//  HomeHeaderStyle+Adapter.swift
//  Presentation
//
//  Created by 소은 on 1/22/26.
//

import ViewModel

public extension TitleHeaderTableViewCell.HeaderStyle {
    init(_ style: HomeHeaderStyle) {
        switch style {
        case .normal: self = .normal
        case .more: self = .more
        }
    }
}
