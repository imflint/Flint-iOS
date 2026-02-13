//
//  Collection+.swift
//  Domain
//
//  Created by 김호성 on 2026.02.13.
//


import Foundation

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
