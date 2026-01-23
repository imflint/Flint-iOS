//
//  TokenStorageFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.23.
//

import Foundation

import Data

protocol TokenStorageFactory {
    func makeTokenStorage() -> TokenStorage
}
