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
    
    private let logoutUseCase: LogoutUseCase
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    public init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
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
        logoutUseCase()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("로그아웃 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] in
                    self?.logoutSuccess.send()
                }
            )
            .store(in: &cancellables)
    }

    public func performWithdrawal() {
        // TODO: 탈퇴 UseCase 연결
        print("회원탈퇴")
    }
    
    // MARK: - Private Methods
    
    private func fetchUserProfile() {
        let mockProfile = UserProfileEntity(
            id: "user123",
            nickname: "플리니",
            profileImageUrl: nil,
            role: .fliner
        )
        userProfile.send(mockProfile)
    }
}
