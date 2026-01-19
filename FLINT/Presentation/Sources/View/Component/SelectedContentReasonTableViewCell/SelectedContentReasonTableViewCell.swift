
//
//  SelectedContentReasonTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/17/26.
//

import UIKit

import SnapKit
import Then

public final class SelectedContentReasonTableViewCell: BaseTableViewCell {
    
    public var onTapClose: (() -> Void)?
    public var onToggleSpoiler: ((Bool) -> Void)?
    public var onChangeReasonText: ((String) -> Void)?
    
    private var isSpoilerOn: Bool = false
    
    //MARK: - UI
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let infoContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(.icCancel, for: .normal)
        $0.tintColor = .flintWhite
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let directorLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let yearLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    private let sectionTitleLabel = UILabel()
    
    private let spoilerLabel = UILabel()
    
    private let checkboxToggleView = ToggleBarView(
        type: .primary,
        isOn: false,
        knobSize: 24,
        contentInset: 2
    )
    private let textView = FlintTextView(placeholder: "이 작품의 매력 포인트를 적어주세요.")
    
    //MARK: - Setup
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        sectionTitleLabel.attributedText = .pretendard(.head3_m_18, text: "이 작품을 선택한 이유", color: .flintWhite)
        spoilerLabel.attributedText = .pretendard(.caption1_m_12, text: "스포일러", color: .flintWhite)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        checkboxToggleView.onValueChanged = { [weak self] isOn in
            self?.onToggleSpoiler?(isOn)
        }
    }
    
    public override func setHierarchy() {
        contentView.addSubviews(containerView, closeButton)
        
        containerView.addSubviews(
            posterImageView,
            infoContainerView,
            sectionTitleLabel,
            spoilerLabel,
            checkboxToggleView,
            textView
        )
        
        infoContainerView.addSubviews(
            titleLabel,
            directorLabel,
            yearLabel
        )
    }
    
    public override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(64)
            $0.leading.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        infoContainerView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
        }
        
        checkboxToggleView.snp.makeConstraints {
            $0.centerY.equalTo(sectionTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(44)
            $0.height.equalTo(28)
        }
        
        spoilerLabel.snp.makeConstraints {
            $0.centerY.equalTo(sectionTitleLabel.snp.centerY)
            $0.trailing.equalTo(checkboxToggleView.snp.leading).offset(-8)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(104)
        }
    }
    
    public override func prepare() {
        super.prepare()
        
        posterImageView.image = nil
        
        titleLabel.attributedText = nil
        directorLabel.attributedText = nil
        yearLabel.attributedText = nil
        
        sectionTitleLabel.attributedText = nil
        spoilerLabel.attributedText = nil
        
        isSpoilerOn = false
        checkboxToggleView.setOn(false, animated: true)
        
        textView.text = ""
        
    }
    
    //MARK: - Configure
    
    public func configure(with item: SelectedContentReasonTableViewCellItem) {
        posterImageView.image = item.posterImage

        titleLabel.attributedText = .pretendard(.head3_m_18, text: item.title, color: .flintWhite)
        directorLabel.attributedText = .pretendard(.body1_r_16, text: item.director, color: .flintGray300)
        yearLabel.attributedText = .pretendard(.body1_r_16, text: item.year, color: .flintGray300)

        sectionTitleLabel.attributedText = .pretendard(.head3_m_18, text: "이 작품을 선택한 이유", color: .flintWhite)
        spoilerLabel.attributedText = .pretendard(.caption1_m_12, text: "스포일러", color: .flintWhite)

        checkboxToggleView.setOn(item.isSpoiler, animated: false)
        
        textView.text = item.reasonText ?? ""

    }
    
    //MARK: - Action
    
    @objc private func didTapClose() {
            onTapClose?()
        }
}

