//
//  ReportRequestDTO.swift
//  Data
//

import Foundation

public struct ReportRequestDTO: Encodable {
    public let reasons: [String]
    public let otherDetail: String?
    
    public init(reasons: [String], otherDetail: String?) {
        self.reasons = reasons
        self.otherDetail = otherDetail
    }
}
