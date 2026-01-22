//
//  ViewControllerFactory.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import UIKit

import ViewModel

public protocol ViewControllerFactory {
    func makeTabBarViewController() -> TabBarViewController
    func makeHomeViewController() -> HomeViewController 
    func makeNicknameViewController() -> NicknameViewController
    func makeAddContentSelectViewController() -> AddContentSelectViewController
    func makeCreateCollectionViewController() -> CreateCollectionViewController
}
