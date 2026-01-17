//
//  SavedContentItemView.swift
//  FLINT
//
//  Created by 소은 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class SavedContentSelectableTableViewCell: BaseTableViewCell {

    // MARK: - Event
    
    var onTapCheckbox: ((Bool) -> Void)?
    
    //MARK: - State
    private var isSelectedItem: Bool = false

    // MARK: - UI Component

    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .flintGray100
    }

    private let infoContainerView = UIView()

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
        $0.lineBreakMode = .byTruncatingTail
    }

    private let checkboxButton = UIButton(type: .system).then {
        $0.tintColor = .clear
        $0.setImage(UIImage.icCheckboxEmpty.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    // MARK: - Setup

    override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        checkboxButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
    }
    
    override func setHierarchy() {
        contentView.addSubviews(posterImageView, infoContainerView, checkboxButton)
        infoContainerView.addSubviews(titleLabel, directorLabel, yearLabel)
    }

    override func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.centerY.equalTo(posterImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(48)
        }

        infoContainerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(checkboxButton.snp.leading)
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        directorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        yearLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func prepare() {
        onTapCheckbox = nil
        
        posterImageView.image = nil
        titleLabel.attributedText = nil
        directorLabel.attributedText = nil
        yearLabel.attributedText = nil
        
        isSelectedItem = false
        updateCheckbox(isSelected: false)
    }

    // MARK: - Configure

    func configure(model: SavedContentItemViewModel, isSelected: Bool) {
        posterImageView.image = model.posterImage
        
        titleLabel.attributedText = .pretendard(.head3_sb_18, text: model.title, color: .flintWhite)
        directorLabel.attributedText = .pretendard(.body1_r_16, text: model.director, color: .flintGray300)
        yearLabel.attributedText = .pretendard(.body1_r_16, text: model.year, color: .flintGray300)
        
        isSelectedItem = isSelected
        updateCheckbox(isSelected: isSelected)
   
    }

    // MARK: - Actions

    @objc private func didTapCheckbox() {
      toggleSelection()
    }

    // MARK: - apply

    private func updateCheckbox(isSelected: Bool) {
        let image = isSelected ? UIImage.icCheckboxFill : UIImage.icCheckboxEmpty
        checkboxButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func toggleSelection() {
        isSelectedItem.toggle()
        updateCheckbox(isSelected: isSelectedItem)
        onTapCheckbox?(isSelectedItem)
    }
}
