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
//    func appleLogin()
}

public protocol LoginViewModelOutput {
    var socialVerifyResultEntity: PassthroughSubject<SocialVerifyResultEntity, Never> { get }
}

public typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

public final class DefaultLoginViewModel: LoginViewModel {
    
    private let socialVerifyUseCase: SocialVerifyUseCase
    
    public var socialVerifyResultEntity: PassthroughSubject<SocialVerifyResultEntity, Never> = .init()
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(socialVerifyUseCase: SocialVerifyUseCase) {
        self.socialVerifyUseCase = socialVerifyUseCase
    }
    
    public func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(completion: kakaoSocialVerify)
        } else {
            UserApi.shared.loginWithKakaoAccount(completion: kakaoSocialVerify)
        }
        
    }
    
    private func kakaoSocialVerify(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            Log.e(error)
            return
        }
        if let accessToken = oauthToken?.accessToken {
            socialVerifyUseCase(
                socialAuthCredential: SocialVerifyEntity(
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
    
    public func appleLogin(authorizationCode: String) {
//        socialVerifyUseCase(socialAuthCredential: SocialVerifyEntity(provider: ., accessToken: <#T##String#>))
    }
}
