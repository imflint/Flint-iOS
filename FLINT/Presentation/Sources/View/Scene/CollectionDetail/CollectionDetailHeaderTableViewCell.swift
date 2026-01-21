//
//  CollectionDetailHeaderTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/20/26.
//

import UIKit

import SnapKit
import Then

public final class CollectionDetailHeaderTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    public var onTapSave: ((Bool) -> Void)?
    
    private var isSaved: Bool = false {
        didSet { updateSaveButtonImage() }
    }
    
    // MARK: - Component
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(resource: .imgBackgroundGradient)
    }
    
    private let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.display2_m_28, text: "한 번 보면 못 빠져나오는\n사랑 이야기", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private var saveButton = UIButton().then {
        $0.setImage(UIImage(resource: .icCollectionSave), for: .normal)
    }
    
    // MARK: - Setup
    
    public override func setHierarchy() {
        contentView.addSubviews(backgroundImageView, titleLabel, saveButton)
    }
    
    public override func setLayout() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(360)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(51)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(backgroundImageView).inset(19)
        }
    }
    
    public override func setStyle() {
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        updateSaveButtonImage()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        onTapSave = nil
        isSaved = false
    }
    
    // MARK: - Public
    public func configure(title: String, isSaved: Bool) {
        titleLabel.attributedText = .pretendard(.display2_m_28, text: title)
        self.isSaved = isSaved
    }
    
    // MARK: - Action
    @objc private func didTapSaveButton() {
        isSaved.toggle()
        onTapSave?(isSaved)
    }
    
    private func updateSaveButtonImage() {
        let image: UIImage = isSaved
        ? UIImage(resource: .icCollectionSaved)
        : UIImage(resource: .icCollectionSave)
        saveButton.setImage(image, for: .normal)
    }
}
