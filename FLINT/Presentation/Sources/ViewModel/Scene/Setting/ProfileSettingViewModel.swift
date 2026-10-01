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
    func modify()
}

public protocol ProfileSettingViewModelOutput {
    var nickname: String? { get set }
    var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> { get }
    var modificationCompleted: PassthroughSubject<Void, Never> { get }
}

public typealias ProfileSettingViewModel = ProfileSettingViewModelInput & ProfileSettingViewModelOutput

public final class DefaultProfileSettingViewModel: ProfileSettingViewModel {
    
    private let uploadUserProfileUseCase: UploadUserProfileUseCase
    private let checkNicknameUseCase: CheckNicknameUseCase
    private let modifyNicknameUseCase: ModifyNicknameUseCase
    private let modifyProfileImageUseCase: ModifyProfileImageUseCase
    
    public var nickname: String?
    public let nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> = .init(nil)
    public let modificationCompleted: PassthroughSubject<Void, Never> = .init()
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
    
    public func modify() {
        let imagePublisher: AnyPublisher<Void, Error>
        if let profileImageKey {
            imagePublisher = modifyProfileImageUseCase(key: profileImageKey).eraseToAnyPublisher()
        } else {
            imagePublisher = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let nicknamePublisher: AnyPublisher<Void, Error>
        if let nickname {
            nicknamePublisher = modifyNicknameUseCase(nickname: nickname).eraseToAnyPublisher()
        } else {
            nicknamePublisher = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        Publishers.Zip(imagePublisher, nicknamePublisher)
            .manageThread()
            .sinkHandledCompletion(receiveValue: { [weak self] _, _ in
                Log.d("Profile modifications completed")
                self?.modificationCompleted.send(())
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
