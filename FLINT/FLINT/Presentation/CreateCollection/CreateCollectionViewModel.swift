//
//  CreateCollectionViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import Foundation
import Combine

final class CreateCollectionViewModel {
    
    struct Input {
        let titleChange: AnyPublisher<String, Never>
    }
    
    struct Output {
        let isDoneEnabled: AnyPublisher<Bool, Never>
    }
    
    //MARK: - Transform
    
    func transform(input: Input) -> Output {
        let title = input.titleChange
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            .removeDuplicates()
            .share()
        
        let isDoneEnabled = title
            .map { !$0.isEmpty }
            .removeDuplicates()
        
        return Output(isDoneEnabled: isDoneEnabled.eraseToAnyPublisher())
    }
}
