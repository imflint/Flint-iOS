//
//  NicknameView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import UIKit

import SnapKit
import Then

public final class NicknameView: BaseView {
    
    // MARK: - Component
    
    public lazy var successToast = Toast.success("사용 가능한 닉네임입니다", customConstraints: { [weak self] in
        guard let self else { return }
        $0.bottom.equalTo(nextButton.snp.top).offset(-8)
    })
    
    public lazy var failureToast = Toast.failure("이미 사용 중인 닉네임입니다", customConstraints: { [weak self] in
        guard let self else { return }
        $0.bottom.equalTo(nextButton.snp.top).offset(-8)
    })
    
    public let profileImageSettingView = ProfileImageSettingView()
    
    public let nicknameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    public let nicknameTitleLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.attributedText = .pretendard(.head3_m_18, text: "어떤 이름으로 불러드릴까요?")
    }
    
    public let nicknameVerifyStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    public let nicknameTextField = FlintTextField(placeholder: "닉네임", maxLength: 8, showLength: true)
    public let nicknameWarningLabel = UILabel().then {
        $0.textColor = .flintError500
        $0.isHidden = true
        $0.attributedText = .pretendard(.body2_r_14, text: "닉네임은 한글, 영어, 숫자만 사용할 수 있어요.")
    }
    
    public let verifyButton = BasicButton(title: "확인").then {
        $0.isEnabled = false
    }
    
    public let nextButton = FlintButton(style: .able, title: "다음").then {
        $0.isEnabled = false
    }
    
    // MARK: - Basic
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        nicknameTextField.addAction(UIAction(handler: nicknameTextFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    public override func setUI() {
        backgroundColor = .flintBackground
    }
    
    public override func setHierarchy() {
        addSubviews(profileImageSettingView, nicknameStackView, nextButton, nicknameWarningLabel)
        nicknameStackView.addArrangedSubviews(nicknameTitleLabel, nicknameVerifyStackView)
        nicknameVerifyStackView.addArrangedSubviews(nicknameTextField, verifyButton)
    }
    
    public override func setLayout() {
        profileImageSettingView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(12)
        }
        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageSettingView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        nicknameWarningLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameVerifyStackView.snp.leading)
            $0.top.equalTo(nicknameVerifyStackView.snp.bottom).offset(8)
        }
        verifyButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
    }
    
    private func nicknameTextFieldEditingChanged(_ action: UIAction) {
        nextButton.isEnabled = false
        guard let textField = action.sender as? FlintTextField else { return }
        guard let count = textField.text?.count else { return }
        verifyButton.isEnabled = count >= 2
    }
}
