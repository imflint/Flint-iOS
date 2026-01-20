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
        let visibilitySelected: AnyPublisher<Bool, Never>
        let selectedCount: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let isDoneEnabled: AnyPublisher<Bool, Never>
    }
    
    //MARK: - Transform
    
    func transform(input: Input) -> Output {
        let titleValid = input.titleChange
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { !$0.isEmpty }
            .removeDuplicates()
        
        let visibilityValid = input.visibilitySelected
            .removeDuplicates()
        
        let countValid = input.selectedCount
            .map { $0 >= 2 }
            .removeDuplicates()
        
        let isDoneEnabled = Publishers
            .CombineLatest3(titleValid, countValid, visibilityValid)
            .map { $0 && $1 && $2 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(isDoneEnabled: isDoneEnabled)
    }
}
