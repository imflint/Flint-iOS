//
//  ReportViewModel.swift
//  Presentation
//
//  Created by 소은 on 5/13/26.
//

import Foundation
import Combine

import Domain

public final class ReportViewModel {
    
    // MARK: - Property
    
    private let reportCollectionUseCase: ReportCollectionUseCase
    private let collectionId: Int64
    private var cancellables = Set<AnyCancellable>()
    
    private static let reasonKeys = ["ABUSE", "OBSCENE", "SPAM", "COPYRIGHT", "OTHER"]
    
    private var selectedRadioIndex: Int = -1
    private var textInput: String = ""
    
    // MARK: - Init
    
    public init(reportCollectionUseCase: ReportCollectionUseCase, collectionId: Int64) {
        self.reportCollectionUseCase = reportCollectionUseCase
        self.collectionId = collectionId
    }
    
    // MARK: - Input
    
    public struct Input {
        public let radioSelected: AnyPublisher<Int, Never>
        public let textInput: AnyPublisher<String, Never>
        public let submitButtonTapped: AnyPublisher<Void, Never>
        
        public init(
            radioSelected: AnyPublisher<Int, Never>,
            textInput: AnyPublisher<String, Never>,
            submitButtonTapped: AnyPublisher<Void, Never>
        ) {
            self.radioSelected = radioSelected
            self.textInput = textInput
            self.submitButtonTapped = submitButtonTapped
        }
    }
    
    // MARK: - Output
    
    public struct Output {
        public let isSubmitEnabled: AnyPublisher<Bool, Never>
        public let submitSuccess: AnyPublisher<Void, Never>
        public let submitError: AnyPublisher<Error, Never>
    }
    
    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        input.radioSelected
            .sink { [weak self] index in self?.selectedRadioIndex = index }
            .store(in: &cancellables)
        
        input.textInput
            .sink { [weak self] text in self?.textInput = text }
            .store(in: &cancellables)
        
        let isSubmitEnabledPublisher = Publishers.CombineLatest(
            input.radioSelected.prepend(-1),
            input.textInput.prepend("")
        )
        .map { radioIndex, text -> Bool in
            if radioIndex == -1 { return false }
            if radioIndex == 4 { return !text.isEmpty }
            return true
        }
        .eraseToAnyPublisher()
        
        let submitResult = input.submitButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self, self.selectedRadioIndex >= 0 else {
                    return Empty().eraseToAnyPublisher()
                }
                let reason = Self.reasonKeys[self.selectedRadioIndex]
                let otherDetail = self.selectedRadioIndex == 4 ? self.textInput : nil
                return self.reportCollectionUseCase(collectionId: self.collectionId, reasons: [reason], otherDetail: otherDetail)
                    .map { Result.success($0) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .share()
        
        let submitSuccess = submitResult
            .compactMap { result -> Void? in
                if case .success = result { return () }
                return nil
            }
            .eraseToAnyPublisher()
        
        let submitError = submitResult
            .compactMap { result -> Error? in
                if case .failure(let error) = result { return error }
                return nil
            }
            .eraseToAnyPublisher()
        
        return Output(
            isSubmitEnabled: isSubmitEnabledPublisher,
            submitSuccess: submitSuccess,
            submitError: submitError
        )
    }
}
