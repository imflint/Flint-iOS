//
//  LabelCheckBox.swift
//  Presentation
//
//  Created by 소은 on 5/8/26.
//

import UIKit

import SnapKit
import Then

public enum CheckBoxPosition {
    case left
    case right
}

public final class LabelCheckBox: BaseView {
    
    // MARK: - Property
    
    private let position: CheckBoxPosition
    
    public var isSelected: Bool = false {
        didSet {
            updateCheckBoxImage()
        }
    }
    
    public var didTapCheckBox: ((Bool) -> Void)?
    
    // MARK: - UI Component
    
    private let checkBoxImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(.body1_r_16)
        $0.textColor = .white
    }
    
    private let containerButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Init
    
    public init(title: String, position: CheckBoxPosition = .left) {
        self.position = position
        super.init(frame: .zero)
        
        checkBoxImageView.image = .icCheckboxEmpty
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    public override func setUI() {
        backgroundColor = .clear
        containerButton.addTarget(self, action: #selector(didTapCheckBoxButton), for: .touchUpInside)
    }
    
    public override func setHierarchy() {
        addSubviews(checkBoxImageView, titleLabel, containerButton)
    }
    
    public override func setLayout() {
        switch position {
        case .left:
            checkBoxImageView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(48)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalTo(checkBoxImageView.snp.trailing)
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
        case .right:
            checkBoxImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(48)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.trailing.equalTo(checkBoxImageView.snp.leading).offset(-16)
                $0.centerY.equalToSuperview()
            }
        }
        
        containerButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Action
    
    @objc private func didTapCheckBoxButton() {
        isSelected.toggle()
        didTapCheckBox?(isSelected)
    }
    
    // MARK: - Custom Method
    
    private func updateCheckBoxImage() {
        checkBoxImageView.image = isSelected ? .icCheckboxFill : .icCheckboxEmpty
    }
    
    // MARK: - Configure
    
    public func configure(isSelected: Bool) {  
        self.isSelected = isSelected
    }
}
