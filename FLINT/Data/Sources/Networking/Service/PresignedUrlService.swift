//
//  File.swift
//  Data
//
//  Created by 김호성 on 2026.05.01.
//

import Combine
import Foundation

import Domain

public protocol PresignedUrlService {
    func uploadImageToS3(imageData: Data, uploadUrl: URL, fileExtension: FileExtension) -> AnyPublisher<Void, Error>
}

public final class DefaultPresignedUrlService: PresignedUrlService {
    
    public init() {
        
    }
    
    public func uploadImageToS3(imageData: Data, uploadUrl: URL, fileExtension: FileExtension) -> AnyPublisher<Void, Error> {
        var request = URLRequest(url: uploadUrl)
        request.httpMethod = "PUT"
        request.setValue(fileExtension.contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                Log.d(result.response)
                guard let response = result.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
}
