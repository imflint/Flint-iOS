//
//  CreateCollectionViewModel.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import Foundation
import Combine

public final class CreateCollectionViewModel {
    
    public struct Input {
        public let titleChange: AnyPublisher<String, Never>
        public let visibilitySelected: AnyPublisher<Bool, Never>
        public let selectedCount: AnyPublisher<Int, Never>
        
        public init(titleChange: AnyPublisher<String, Never>, visibilitySelected: AnyPublisher<Bool, Never>, selectedCount: AnyPublisher<Int, Never>) {
            self.titleChange = titleChange
            self.visibilitySelected = visibilitySelected
            self.selectedCount = selectedCount
        }
    }
    
    public struct Output {
        public let isDoneEnabled: AnyPublisher<Bool, Never>
        
        init(isDoneEnabled: AnyPublisher<Bool, Never>) {
            self.isDoneEnabled = isDoneEnabled
        }
    }
    
    public init() {
        
    }
    
    //MARK: - Transform
    
    public func transform(input: Input) -> Output {
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
