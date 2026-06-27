//
//  TermsAPI.swift
//  Data
//
//  Created by 김호성 on 2026.05.29.
//

import Foundation

import Moya

public enum TermsAPI {
    case getTerms
    case getTerm(id: String)
    case agreeTerms(ids: [String])
}
