//
//  SettingViewModel.swift
//  Presentation
//
//  Created by 소은 on 5/2/26.
//

import Combine
import Foundation

import Domain

// MARK: - SettingViewModelInput

public protocol SettingViewModelInput {
    func editProfileTapped()
    func accountTapped()
    func privacyPolicyTapped()
    func termsOfServiceTapped()
    func logoutTapped()
    func withdrawalTapped()
}

// MARK: - SettingViewModelOutput

public protocol SettingViewModelOutput {
    var userProfile: CurrentValueSubject<UserProfileEntity?, Never> { get }
    var navigateToEditProfile: PassthroughSubject<Void, Never> { get }
    var navigateToAccount: PassthroughSubject<Void, Never> { get }
    var navigateToPrivacyPolicy: PassthroughSubject<Void, Never> { get }
    var navigateToTermsOfService: PassthroughSubject<Void, Never> { get }
    var showLogoutAlert: PassthroughSubject<Void, Never> { get }
    var showWithdrawalAlert: PassthroughSubject<Void, Never> { get }
    var logoutSuccess: PassthroughSubject<Void, Never> { get }
}

// MARK: - SettingViewModel

public typealias SettingViewModel = SettingViewModelInput & SettingViewModelOutput

// MARK: - DefaultSettingViewModel

public final class DefaultSettingViewModel: SettingViewModel {
    
    // MARK: - Output
    
    public var userProfile: CurrentValueSubject<UserProfileEntity?, Never> = .init(nil)
    public var navigateToEditProfile: PassthroughSubject<Void, Never> = .init()
    public var navigateToAccount: PassthroughSubject<Void, Never> = .init()
    public var navigateToPrivacyPolicy: PassthroughSubject<Void, Never> = .init()
    public var navigateToTermsOfService: PassthroughSubject<Void, Never> = .init()
    public var showLogoutAlert: PassthroughSubject<Void, Never> = .init()
    public var showWithdrawalAlert: PassthroughSubject<Void, Never> = .init()
    public var logoutSuccess: PassthroughSubject<Void, Never> = .init()
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    public init() {
        // TODO: UseCase 주입
        fetchUserProfile()
    }
    
    // MARK: - Input
    
    public func editProfileTapped() {
        navigateToEditProfile.send()
    }
    
    public func accountTapped() {
        navigateToAccount.send()
    }
    
    public func privacyPolicyTapped() {
        navigateToPrivacyPolicy.send()
    }
    
    public func termsOfServiceTapped() {
        navigateToTermsOfService.send()
    }
    
    public func logoutTapped() {
        showLogoutAlert.send()
    }
    
    public func withdrawalTapped() {
        showWithdrawalAlert.send()
    }
    
    public func performLogout() {
        // TODO: UseCase 연결
        logoutSuccess.send()
    }

    public func performWithdrawal() {
        // TODO: 탈퇴 UseCase 연결
        print("Withdrawal performed")
    }
    
    // MARK: - Private Methods
    
    private func fetchUserProfile() {
        // TODO: UseCase 연결
        // 임시 Mock 데이터
        let mockProfile = UserProfileEntity(
            id: "user123",
            nickname: "한비두비네비",
            profileImageUrl: nil,
            role: .fliner  
        )
        userProfile.send(mockProfile)
    }
}
