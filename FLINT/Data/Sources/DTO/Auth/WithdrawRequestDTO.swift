//
//  WithdrawRequestDTO.swift
//  Data
//

import Foundation

public struct WithdrawRequestDTO: Encodable {
    public let agreedTermsIds: [String]
    
    public init(agreedTermsIds: [String]) {
        self.agreedTermsIds = agreedTermsIds
    }
}
