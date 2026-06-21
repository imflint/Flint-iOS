//
//  SignUpTerm.swift
//  Domain
//
//  Created by 김호성 on 2026.06.10.
//

import Foundation

public enum SignUpTerm: String, Sendable, CaseIterable {
    case service = "SERVICE"
    case privacy = "PRIVACY"
}

extension SignUpTerm {
    public init?(id: Int) {
        switch id {
        case 1:
            self = .service
        case 2:
            self = .privacy
        default:
            return nil
        }
    }
    
    public var id: Int {
        switch self {
        case .service:
            return 1
        case .privacy:
            return 2
        }
    }
    
    public var title: String {
        switch self {
        case .service:
            return "서비스 이용 약관 동의"
        case .privacy:
            return "개인정보 처리 방침 동의"
        }
    }
    
    public var description: String {
        switch self {
        case .service:
            return """
                   본 약관은 서비스 이용과 관련한 기본적인 권리·의무 및 책임사항을 규정합니다.
                   """
        case .privacy:
            return """
                   서비스 제공을 위해 개인정보를 수집 · 이용합니다. 콘텐츠 추천, 컬렉션 생성 및 공유, 맞춤형 탐색 경험 제공을 위한 이용 기록 및 취향 정보 처리 내용이 포함됩니다.
                   
                   수집 항목 : 계정 정보, 취향 정보, 컬렉션 및 콘텐츠 활동, 서비스 이용 기록 등
                   
                   수집 목적: 개인화 추천 제공, 컬렉션 생성 및 공유, 서비스 운영 및 이용자 보호
                   """
        }
    }
    
    public var isRequired: Bool {
        switch self {
        case .service, .privacy:
            return true
        }
    }
}
