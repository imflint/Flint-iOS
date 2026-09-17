//
//  File.swift
//  Presentation
//
//  Created by 김호성 on 2026.01.22.
//

import Foundation

extension String {
    func isValidNickname() -> Bool {
        let nicknameRegex = "^[가-힣a-zA-Z0-9]{2,10}$"
        return NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: self)
    }
    
    func isIncompleteHangul() -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎㅏ-ㅣ]+$"
        return NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: self)
    }
}
