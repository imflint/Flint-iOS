//
//  ExampleView.swift
//  FLINT
//
//  Created by 진소은 on 1/7/26.
//

import UIKit

import SnapKit
import Then

final class ExampleView: BaseView {
    
    // MARK: - Properties
    
    var onTapButton: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "요기 타이틀"
    //    $0.applyFontStyle(.head1_m_22, textColor: .black)
    }
    
    private let teamLabel = UILabel().then {
        $0.text = "파트 이름 나올 예정"
   //     $0.applyFontStyle(.body2_r_14, textColor: .flintError500)
    }
    
    private var button = UIButton().then {
    //    $0.setTitle("눌러보쇼 ㅋ", style: .body1_r_16)
        $0.backgroundColor = .flintPrimary300
    }
    
    // MARK: - Setup
    
    override func setHierarchy() {
        self.addSubviews(titleLabel, teamLabel, button)
        setEvent()
    }
    
    override func setLayout() {
        self.backgroundColor = .white
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
        }
        
        teamLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(teamLabel.snp.bottom).offset(50)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Custom Methods
    
    private func setEvent() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        onTapButton?()
    }
    
    func setLabel(_ title: String, team: String) {
        titleLabel.text = title
        teamLabel.text = team
    }
}
