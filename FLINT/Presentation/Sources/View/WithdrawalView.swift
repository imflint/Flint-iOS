//
//  WithdrawalView.swift
//  Presentation
//
//  Created by 소은 on 5/13/26.
//
import UIKit

import SnapKit
import Then

public final class WithdrawalView: BaseView {
    
    // MARK: - UI Component
    
    public let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .flintWhite
    }
    
    public let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .flintGray300
    }
    
    public let seperatorLine = UIView().then {
        $0.backgroundColor = .flintGray600
    }
    
    public let agreementCheckBox = LabelCheckBox(
        title: "위 유의사항을 확인했습니다",
        position: .right
    )
    
    public let withdrawButton = BasicButton(
        title: "탈퇴하기",
        titleColor: .white,
        titleStyle: .body1_sb_16,
        buttonColor: .flintError500
    ).then {
        $0.isEnabled = false
    }
    
    // MARK: - Override
    
    public override func setUI() {
        backgroundColor = .flintBackground
        
        titleLabel.attributedText = .pretendard(
            .head1_sb_22,
            text: "계정 삭제 시\nFlint에서 기록한 모든 정보가 사라져요"
        )
        
        let descriptions = [
            "1. 회원 탈퇴 시 즉시 탈퇴 처리되며, 서비스 이용이 제한됩니다.",
            "2. 저장한 작품 및 등록한 컬렉션, 취향 키워드 등 모든 이용 기록이 삭제되며, 다시 복구할 수 없습니다.",
            "3. 동일한 계정 정보로 재가입하더라도 이전의 이용 기록은 복원되지 않습니다.",
            "4. 관련 법령에 따라 일부 정보는 일정 기간 보관될 수 있으며, 해당 정보는 법적 의무 이외의 목적으로 사용되지 않습니다."
        ]
        descriptionLabel.attributedText = .pretendard(
            .body1_m_16,
            text: descriptions.joined(separator: "\n")
        )
    }
    
    public override func setHierarchy() {
        addSubviews(titleLabel, descriptionLabel, seperatorLine, agreementCheckBox, withdrawButton)
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        seperatorLine.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        agreementCheckBox.snp.makeConstraints {
            $0.top.equalTo(seperatorLine.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(48)
        }
    }
}
