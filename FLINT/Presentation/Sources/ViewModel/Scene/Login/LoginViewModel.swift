//
//  LoginViewModel.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import Combine

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import Domain

public protocol LoginViewModelInput {
    func kakaoLogin()
}

public protocol LoginViewModelOutput {
    var socialVerifyResultEntity: CurrentValueSubject<SocialVerifyResultEntity?, Never> { get set }
}

public typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

public final class DefaultLoginViewModel: LoginViewModel {
    
    private let socialVerifyUseCase: SocialVerifyUseCase
    
    public var socialVerifyResultEntity: CurrentValueSubject<SocialVerifyResultEntity?, Never> = .init(nil)
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(socialVerifyUseCase: SocialVerifyUseCase) {
        self.socialVerifyUseCase = socialVerifyUseCase
    }
    
    public func kakaoLogin() {
        guard UserApi.isKakaoTalkLoginAvailable() else {
            return
        }
        UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
            guard let self else { return }
            if let error = error {
                Log.e(error)
                return
            }
            if let accessToken = oauthToken?.accessToken {
                socialVerifyUseCase.socialVerify(
                    socialVerifyEntity: SocialVerifyEntity(
                        provider: .kakao,
                        accessToken: accessToken
                    )
                )
                .manageThread()
                .sinkHandledCompletion { socialVerifyResultEntity in
                    Log.d(socialVerifyResultEntity)
                    self.socialVerifyResultEntity.send(socialVerifyResultEntity)
                }
                .store(in: &cancellables)
            }
        }
    }
}
