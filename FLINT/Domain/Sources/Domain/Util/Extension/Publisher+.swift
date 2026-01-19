//
//  Publisher+Ext.swift
//  Domain
//
//  Created by 김호성 on 2025.03.03.
//

import Foundation
import Combine

extension Publisher {
    public func sinkHandledCompletion(receiveValue: @escaping ((Self.Output) -> Void), filename: String = #file, line: Int = #line, funcName: String = #function) -> AnyCancellable {
        return self.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                Log.e(error.localizedDescription, filename: filename, line: line, funcName: funcName)
            }
        }, receiveValue: receiveValue)
    }
    
    public func manageThread() -> AnyPublisher<Output, Failure> {
        return self
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
