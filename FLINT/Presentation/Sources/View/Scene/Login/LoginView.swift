//
//  LoginView.swift
//  Presentation
//
//  Created by 진소은 on 1/22/26.
//

import UIKit

import SnapKit
import Then

public final class LoginView: BaseView {

    // MARK: - UI

    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(named: "img_background_login", in: .module, compatibleWith: nil)
    }

    private let kakaoButton = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0/255, alpha: 1.0)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
//        $0.adjustsImageWhenHighlighted = false
    }

    private let kakaoIconView = UIImageView().then {
        $0.image = UIImage(named: "img_kakao", in: .module, compatibleWith: nil)
        $0.contentMode = .scaleAspectFit
    }

    private let kakaoTitleLabel = UILabel().then {
        $0.attributedText = .pretendard(.body1_m_16,
                                        text: "카카오로 시작하기",
                                        color: .flintBackground)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }

    // MARK: - Callback

    public var onTapKakao: (() -> Void)?

    // MARK: - Override

    public override func setUI() {
        kakaoButton.addTarget(self, action: #selector(didTapKakao), for: .touchUpInside)
        kakaoButton.accessibilityLabel = "카카오로 시작하기"
    }

    public override func setHierarchy() {
        addSubview(backgroundImageView)
        addSubview(kakaoButton)

        kakaoButton.addSubview(kakaoIconView)
        kakaoButton.addSubview(kakaoTitleLabel)
    }

    public override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        kakaoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            $0.height.equalTo(56)
        }

        kakaoIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        kakaoTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Action

    @objc private func didTapKakao() {
        onTapKakao?()
    }
}
