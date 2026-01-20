//
//  OnboardingDoneView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

import SnapKit
import Then

class OnboardingDoneView: BaseView {
    
    let subtitleLabel = UILabel().then {
        $0.attributedText = .pretendard(.body1_r_16, text: "취향이 보이기 시작했어요")
        $0.textColor = .flintPrimary200
    }
    
    let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.display2_m_28, text: "Flint에서 끌리는 콘텐츠를 만나러 가볼까요?")
        $0.textColor = .flintWhite
        $0.numberOfLines = 2
    }
    
    let imageContainerView = UIView()
    let mainImageView = UIImageView().then {
        $0.image = .imgOnboarding
        $0.contentMode = .scaleAspectFill
    }
    
    let startButton = FlintButton(style: .able, title: "시작하기")
    
    // MARK: - Setup
    
    override func setUI() {
        backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        addSubviews(
            subtitleLabel,
            titleLabel,
            imageContainerView,
            startButton
        )
        imageContainerView.addSubview(mainImageView)
    }
    
    override func setLayout() {
        subtitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        imageContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        mainImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(mainImageView.snp.width)
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(imageContainerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
