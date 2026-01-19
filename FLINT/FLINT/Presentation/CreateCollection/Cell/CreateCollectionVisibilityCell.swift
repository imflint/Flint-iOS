//
//  CreateCollectionVisibilityCell.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class CreateCollectionVisibilityCell: BaseTableViewCell {
    
    enum Visibility {
        case `public`
        case `private`
    }
    
    var onChangeVisibility: ((Visibility) -> Void)?
    
    private var selectedVisibility: Visibility?
    
    //MARK: - UI
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = .pretendard(.head3_m_18, text: "컬렉션 공개 여부", color: .flintWhite)
    }
    
    private let publicButton = FlintButton(
        style: .outline,
        title: "공개",
        image: .icShare,
        equalTitleWidthWith: "비공개"
    )
    
    private let privateButton = FlintButton(
        style: .outline,
        title: "비공개",
        image: .icLock
    )
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    //MARK: - Setup
    
    override func setStyle() {
        backgroundColor = .flintBackground
        contentView.backgroundColor = .flintBackground
    }
    
    override func setHierarchy() {
        contentView.addSubviews(titleLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(publicButton, privateButton)
        setAction()
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    override func prepare() {
        onChangeVisibility = nil
        applySelectionUI()
    }
}

//MARK: - Action

private extension CreateCollectionVisibilityCell {
    
    func setAction() {
        publicButton.addTarget(self, action: #selector(didTapPublic), for: .touchUpInside)
        privateButton.addTarget(self, action: #selector(didTapPrivate), for: .touchUpInside)
        applySelectionUI()
    }
    
    @objc func didTapPublic() {
        selectedVisibility = .public
        applySelectionUI()
        onChangeVisibility?(.public)
    }
    
    @objc func didTapPrivate() {
        selectedVisibility = .private
        applySelectionUI()
        onChangeVisibility?(.private)
    }
    
    func applySelectionUI() {
        publicButton.style = .outline
        privateButton.style = .outline
        
        if selectedVisibility == .public {
            publicButton.style = .colorOutline
        } else if selectedVisibility == .private {
            privateButton.style = .colorOutline
        }
        
        publicButton.isEnabled = true
        privateButton.isEnabled = true
    }
}
