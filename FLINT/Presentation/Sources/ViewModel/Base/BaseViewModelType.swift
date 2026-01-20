//
//  BaseViewModelType.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import Combine

protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
