//
//  FileExtension+.swift
//  Data
//
//  Created by 김호성 on 2026.05.01.
//

import Foundation

import Domain

extension FileExtension {
    package var requestParameter: String {
        switch self {
        case .jpg:
            return "JPG"
        case .jpeg:
            return "JPEG"
        case .png:
            return "PNG"
        case .gif:
            return "GIF"
        case .webp:
            return "WEBP"
        case .svg:
            return "SVG"
        case .pdf:
            return "PDF"
        }
    }
}
