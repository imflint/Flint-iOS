//
//  PresignedUrlServiceFactory.swift
//  FLINT
//
//  Created by 김호성 on 2026.05.08.
//

import Foundation

import Data

protocol PresignedUrlServiceFactory {
    var presignedUrlService: PresignedUrlService { get set }
    
    func makePresignedUrlService() -> PresignedUrlService
}

extension PresignedUrlServiceFactory {
    func makePresignedUrlService() -> PresignedUrlService {
        return presignedUrlService
    }
}
