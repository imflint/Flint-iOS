//
//  ReportView.swift
//  Presentation
//
//  Created by 소은 on 5/13/26.
//

import UIKit

import SnapKit
import Then

public final class ReportView: BaseView {
    
    // MARK: - UI Component
    
    public let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .flintWhite
    }
    
    public let subtitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .flintGray100
    }
    
    public let radioButtons: [LabelCheckBox] = [
        LabelCheckBox(title: "욕설·혐오 표현이 포함된 콘텐츠", position: .left),
        LabelCheckBox(title: "음란하거나 선정적인 콘텐츠", position: .left),
        LabelCheckBox(title: "광고·홍보 또는 스팸성 콘텐츠", position: .left),
        LabelCheckBox(title: "저작권을 침해한 콘텐츠", position: .left),
        LabelCheckBox(title: "기타", position: .left)
    ]
    
    public let textView = FlintTextView(placeholder: "신고 사유를 작성해주세요.", maxLength: 200)
    
    public let textLengthLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.textAlignment = .right
    }
    
    private let warningContainer = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 12
    }
    
    private let infoIcon1 = UIImageView().then {
        $0.image = .icInfo
        $0.contentMode = .scaleAspectFit
    }
    
    private let warningLabel1 = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .flintGray400
    }
    
    private let infoIcon2 = UIImageView().then {
        $0.image = .icInfo
        $0.contentMode = .scaleAspectFit
    }
    
    private let warningLabel2 = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .flintGray400
    }
    
    public let submitButton = BasicButton(
        title: "제출",
        titleColor: .white,
        titleStyle: .body1_m_16,
        buttonColor: .flintPrimary300
    ).then {
        $0.isEnabled = false
    }
    
    // MARK: - Override
    
    public override func setUI() {
        backgroundColor = .flintBackground
        
        titleLabel.attributedText = .pretendard(
            .head1_sb_22,
            text: "이 컬렉션을 신고하시겠어요?"
        )
        
        subtitleLabel.attributedText = .pretendard(
            .body1_r_16,
            text: "신고해주신 내용은 검토를 통해 반영됩니다."
        )
        
        warningLabel1.attributedText = .pretendard(
            .caption1_m_12,
            text: "신고 전에 해당 콘텐츠가 신고 대상에 해당하는지 한 번 더 확인해 주세요."
        )
        
        warningLabel2.attributedText = .pretendard(
            .caption1_m_12,
            text: "신고된 콘텐츠는 플린트 이용 약관 및 운영 정책에 따라 검토되며, 필요 시 활동 제한 등의 조치가 적용될 수 있습니다."
        )
        textLengthLabel.attributedText = .pretendard(
            .caption1_m_12,
            text: "0/200"
        )
    }
    
    public override func setHierarchy() {
        addSubviews(
            titleLabel,
            subtitleLabel,
            textView,
            textLengthLabel,
            warningContainer,
            submitButton
        )
        radioButtons.forEach { addSubview($0) }
        warningContainer.addSubviews(infoIcon1, warningLabel1, infoIcon2, warningLabel2)
    }
    
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        for (index, button) in radioButtons.enumerated() {
            button.snp.makeConstraints {
                if index == 0 {
                    $0.top.equalTo(subtitleLabel.snp.bottom).offset(28)
                } else {
                    $0.top.equalTo(radioButtons[index - 1].snp.bottom).offset(24)
                }
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(24)
            }
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(radioButtons.last!.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(128)
        }
        
        textLengthLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        warningContainer.snp.makeConstraints {
            $0.top.equalTo(textLengthLabel.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        infoIcon1.snp.makeConstraints {
            $0.top.equalTo(warningLabel1)
            $0.leading.equalToSuperview().inset(12)
            $0.width.height.equalTo(16)
        }
        
        warningLabel1.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalTo(infoIcon1.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        infoIcon2.snp.makeConstraints {
            $0.top.equalTo(warningLabel2)
            $0.leading.equalToSuperview().inset(12)
            $0.width.height.equalTo(16)
        }
        
        warningLabel2.snp.makeConstraints {
            $0.top.equalTo(warningLabel1.snp.bottom).offset(10)
            $0.leading.equalTo(infoIcon2.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(48)
        }
    }
}
