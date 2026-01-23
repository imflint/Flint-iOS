//
//  SplashView.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import UIKit

import Lottie
import SnapKit
import Then

public final class SplashView: BaseView {

    private let animationView = LottieAnimationView().then {
        $0.contentMode = .scaleAspectFill
        $0.loopMode = .playOnce
        $0.backgroundBehavior = .pauseAndRestore
    }

    public var onFinished: (() -> Void)?

    public override func setUI() {
        backgroundColor = .black
        animationView.animation = LottieAnimation.named("splash", bundle: .module)
    }

    public override func setHierarchy() {
        addSubview(animationView)
    }

    public override func setLayout() {
        animationView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public func play() {
        animationView.play { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self?.onFinished?()
            }
        }
    }
}
