//
//  UserRole.swift
//  Domain
//
//  Created by 김호성 on 2026.02.08.
//

import Foundation

public enum UserRole: String, Equatable {
    /// 관리자 - 시스템 전체 관리 권한
    case admin = "ADMIN"
    
    /// 일반 사용자 - 컬렉션 생성 및 관리 가능
    case fliner = "FLINER"
    
    /// 게스트 사용자 - 조회만 가능
    case fling = "FLING"
    
    case unknown
}
