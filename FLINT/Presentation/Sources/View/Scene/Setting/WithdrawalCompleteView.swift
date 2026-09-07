//
//  WithdrawalCompleteView.swift
//  FLINT
//
//  Created by 진소은 on 9/6/26.
//

import UIKit

import SnapKit
import Then

public final class WithdrawalCompleteView: BaseView {

    // MARK: - UI

    private let iconImageView = UIImageView().then {
        $0.image = .icCheckGradient
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = .pretendard(.head1_sb_22, text: "회원 탈퇴 완료", color: .flintWhite)
    }

    private let captionLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.attributedText = .pretendard(
            .body1_m_16,
            text: "그동안 Flint를 이용해주셔서\n진심으로 감사 드립니다",
            color: .flintGray300,
            alignment: .center
        )
    }

    public let goHomeButton = FlintButton(style: .able, title: "첫 화면으로 이동하기")

    // MARK: - Setup

    public override func setUI() {
        backgroundColor = .flintBackground
    }

    public override func setHierarchy() {
        addSubviews(iconImageView, titleLabel, captionLabel, goHomeButton)
    }

    public override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
            $0.size.equalTo(96)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        captionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        goHomeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(48)
        }
    }
}
