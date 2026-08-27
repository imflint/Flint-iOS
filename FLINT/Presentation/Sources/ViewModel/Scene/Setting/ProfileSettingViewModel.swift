//
//  File.swift
//  Presentation
//
//  Created by Hosung.Kim on 2026.08.24.
//

import Combine
import Foundation
import UIKit

import Domain

public protocol ProfileSettingViewModelInput {
    func uploadProfileImage(_ image: UIImage)
    func checkNickname(_ nickname: String)
    func modifyProfileImage()
    func modifyNickname()
}

public protocol ProfileSettingViewModelOutput {
    var nickname: String? { get set }
    var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> { get }
}

public typealias ProfileSettingViewModel = ProfileSettingViewModelInput & ProfileSettingViewModelOutput

public final class DefaultProfileSettingViewModel: ProfileSettingViewModel {
    
    private let uploadUserProfileUseCase: UploadUserProfileUseCase
    private let checkNicknameUseCase: CheckNicknameUseCase
    private let modifyNicknameUseCase: ModifyNicknameUseCase
    private let modifyProfileImageUseCase: ModifyProfileImageUseCase
    
    public var nickname: String?
    public let nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> = .init(nil)
    private var profileImageKey: String?
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(
        uploadUserProfileUseCase: UploadUserProfileUseCase,
        checkNicknameUseCase: CheckNicknameUseCase,
        modifyNicknameUseCase: ModifyNicknameUseCase,
        modifyProfileImageUseCase: ModifyProfileImageUseCase
    ) {
        self.uploadUserProfileUseCase = uploadUserProfileUseCase
        self.checkNicknameUseCase = checkNicknameUseCase
        self.modifyNicknameUseCase = modifyNicknameUseCase
        self.modifyProfileImageUseCase = modifyProfileImageUseCase
    }
    
    public func uploadProfileImage(_ image: UIImage) {
        uploadUserProfileUseCase(image)
            .sinkHandledCompletion(receiveValue: { [weak self] imageKey in
                self?.profileImageKey = imageKey
                Log.d("Profile image uploaded")
            })
            .store(in: &cancellables)
    }
    
    public func modifyProfileImage() {
        guard let profileImageKey else { return }
        modifyProfileImageUseCase(key: profileImageKey)
            .sinkHandledCompletion(receiveValue: { _ in
                Log.d("Profile image modified")
            })
            .store(in: &cancellables)
    }
    
    public func modifyNickname() {
        guard let nickname else { return }
        modifyNicknameUseCase(nickname: nickname)
            .sinkHandledCompletion(receiveValue: { _ in
                Log.d("Nickname modified")
            })
            .store(in: &cancellables)
    }
    
    public func checkNickname(_ nickname: String) {
        guard nickname.isValidNickname() else {
            nicknameValidState.send(.invalid)
            return
        }
        checkNicknameUseCase(nickname)
            .manageThread()
            .sinkHandledCompletion(receiveValue: { [weak self] isValidNickname in
                self?.nicknameValidState.send(isValidNickname ? .valid : .duplicate)
                if isValidNickname {
                    self?.nickname = nickname
                }
            })
            .store(in: &cancellables)
    }
}
