//
//  OnboardingViewModel.swift
//  Presentation
//
//  Created by 김호성 on 2026.01.20.
//

import Combine
import Foundation
import UIKit

import Domain

public protocol OnboardingViewModelInput {
    // nickname
    func uploadProfileImage(_ image: UIImage)
    func checkNickname(_ nickname: String)
    
    // content select
    func fetchPopularContents()
    func searchContents(_ keyword: String)
    func clickContent(_ content: ContentEntity)
    func deleteContent(_ content: ContentEntity)
    
    // onboardingDone
    func signup()
}

public protocol OnboardingViewModelOutput {
    // terms
    var agreedTermsIds: CurrentValueSubject<[String], Never> { get }
    
    // nickname
    var nickname: CurrentValueSubject<String, Never> { get }
    var nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> { get }
    
    // content select
    var requiredContentCount: Int { get }
    var contents: CurrentValueSubject<[ContentEntity], Never> { get }
    var selectedContents: CurrentValueSubject<[ContentEntity], Never> { get }
    
    var userId: CurrentValueSubject<String?, Never> { get }
}

public typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

public final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let uploadUserProfileUseCase: UploadUserProfileUseCase
    private let checkNicknameUseCase: CheckNicknameUseCase
    private let fetchPopularContentsUseCase: FetchPopularContentsUseCase
    private let searchContentsUseCase: SearchContentsUseCase
    private let signupUseCase: SignupUseCase
    
    #warning("TODO: - Temp. 약관 동의 구현 후 수정할 것!!!!")
    public let agreedTermsIds: CurrentValueSubject<[String], Never> = .init(["1", "2"])
    
    public let nickname: CurrentValueSubject<String, Never> = .init("")
    public let nicknameValidState: CurrentValueSubject<NicknameValidState?, Never> = .init(nil)
    private var profileImageKey: String?
    
    public let requiredContentCount: Int = 7
    public let contents: CurrentValueSubject<[ContentEntity], Never> = .init([])
    public let selectedContents: CurrentValueSubject<[ContentEntity], Never> = .init([])
    
    public let selectedOtt: CurrentValueSubject<[Ott], Never> = .init([])
    public let userId: CurrentValueSubject<String?, Never> = .init(nil)
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(
        uploadUserProfileUseCase: UploadUserProfileUseCase,
        checkNicknameUseCase: CheckNicknameUseCase,
        fetchPopularContentsUseCase: FetchPopularContentsUseCase,
        searchContentsUseCase: SearchContentsUseCase,
        signupUseCase: SignupUseCase,
    ) {
        self.uploadUserProfileUseCase = uploadUserProfileUseCase
        self.checkNicknameUseCase = checkNicknameUseCase
        self.fetchPopularContentsUseCase = fetchPopularContentsUseCase
        self.searchContentsUseCase = searchContentsUseCase
        self.signupUseCase = signupUseCase
    }
    
    public func uploadProfileImage(_ image: UIImage) {
        uploadUserProfileUseCase(image)
            .sinkHandledCompletion(receiveValue: { [weak self] imageKey in
                self?.profileImageKey = imageKey
                Log.d("Profile image uploaded")
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
                    self?.nickname.send(nickname)
                }
            })
            .store(in: &cancellables)
    }
    
    public func fetchPopularContents() {
        fetchPopularContentsUseCase()
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.contents.send(contents)
            }
            .store(in: &cancellables)
    }
    
    public func searchContents(_ keyword: String) {
        searchContentsUseCase(keyword: keyword)
            .manageThread()
            .sinkHandledCompletion { [weak self] contents in
                self?.contents.send(contents)
            }
            .store(in: &cancellables)
    }
    
    public func clickContent(_ content: ContentEntity) {
        if let index = selectedContents.value.firstIndex(of: content) {
            selectedContents.value.remove(at: index)
        } else {
            selectedContents.value.insert(content, at: 0)
        }
    }
    
    public func deleteContent(_ content: ContentEntity) {
        selectedContents.value.removeAll(where: {
            content == $0
        })
    }
    
    public func clickOtt(_ ott: Ott) {
        if let index = selectedOtt.value.firstIndex(of: ott) {
            selectedOtt.value.remove(at: index)
        } else {
            selectedOtt.value.append(ott)
        }
    }
    
    public func signup() {
        signupUseCase(
            userInfo: SignupInfoEntity(
                nickname: nickname.value,
                profileImage: profileImageKey,
                favoriteContentIds: selectedContents.value.compactMap({ content in
                    Int(content.id)
                }),
                agreedTermsIds: agreedTermsIds.value
            )
        )
        .manageThread()
        .sinkHandledCompletion { [weak self] userId in
            self?.userId.send(userId)
        }
        .store(in: &cancellables)
    }
}
