//
//  BaseBottomSheetView.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

enum BottomSheetContent {
    case ott(platforms: [OTTPlatform])
    case savedUsers(users: [SavedUserRowItem])
}

final class BaseBottomSheetView: BaseView {
    
    // MARK: - Public Event
    
    var onTapDim: (() -> Void)?
    
    // MARK: - UI
    
    let dimView = UIView().then {
        $0.backgroundColor = .flintOverlay
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private let grabberView = UIView().then {
        $0.backgroundColor = .flintGray500
        $0.layer.cornerRadius = 2
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.isHidden = true
    }
    
    private let countSaveUser = UILabel().then {
        $0.numberOfLines = 1
        $0.isHidden = true
    }
    
    private let contentContainerView = UIView()
    private var titleText: String?
    private var contentTopToGrabber: Constraint?
    private var contentTopToTitle: Constraint?
    
    // MARK: - Public API
    
    func configure(title: String?,
                   count: Int? = nil
    ) {
        let hasTitle = (title != nil)
        
        if let title {
            titleLabel.attributedText = .pretendard(
                .head3_sb_18,
                text: title,
                color: .flintGray50
            )
            titleLabel.isHidden = false
        } else {
            titleLabel.attributedText = nil
            titleLabel.isHidden = true
        }

        
        if let count {
            countSaveUser.attributedText = .pretendard(
                .head3_sb_18,
                text: "\(count)",
                color: .flintWhite
            )
            countSaveUser.isHidden = !hasTitle
        } else {
            countSaveUser.text = nil
            countSaveUser.isHidden = true
        }
        
        contentTopToGrabber?.isActive = !hasTitle
        contentTopToTitle?.isActive = hasTitle
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setContentView(_ view: UIView) {
        contentContainerView.subviews.forEach { $0.removeFromSuperview() }
        contentContainerView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Setup
    
    override func setUI() {
        addSubviews(dimView, containerView)
        containerView.addSubviews(grabberView, titleStackView)
        titleStackView.addArrangedSubviews(titleLabel, countSaveUser)
        
        containerView.addSubview(contentContainerView)
        
        setAction()
    }
    
    override func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        grabberView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(4)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        countSaveUser.setContentHuggingPriority(.required, for: .horizontal)
        countSaveUser.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentContainerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            
            contentTopToGrabber = $0.top.equalTo(grabberView.snp.bottom).offset(16).constraint
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(24)
            contentTopToTitle   = $0.top.equalTo(titleStackView.snp.bottom).offset(16).constraint
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        contentTopToTitle?.isActive = false
        contentTopToGrabber?.isActive = true
        
    }
    
    // MARK: - Action
    
    private func setAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDim))
        dimView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapDim() {
        onTapDim?()
    }
}
