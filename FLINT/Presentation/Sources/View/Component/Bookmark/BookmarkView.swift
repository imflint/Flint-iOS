//
//  BookmarkView.swift
//  FLINT
//
//  Created by 소은 on 1/14/26.
//

import UIKit

import SnapKit
import Then

public final class BookmarkView: BaseView {
    
    //MARK: - Property
    
    public var onTap: ((Bool) -> Void)?
    
    private var isBookmarked: Bool = false
    
    //MARK: - Component
    
    private let bookmarkButton = UIButton(type: .system).then {
        $0.setImage(.icBookmarkEmpty, for: .normal)
    }
    private let countLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    //MARK: - Setup
    
    public override func setUI() {
        addSubviews(bookmarkButton, countLabel)
        bookmarkButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    public override func setLayout() {
        bookmarkButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(bookmarkButton.snp.bottom).offset(2)
            $0.centerX.equalTo(bookmarkButton.snp.centerX)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method

    private func updateIcon(isBookmarked: Bool) {
        let image = isBookmarked ? UIImage.icBookmarkFill : UIImage.icBookmarkEmpty
        bookmarkButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    @objc private func didTap() {
        isBookmarked.toggle()
        updateIcon(isBookmarked: isBookmarked)
        onTap?(isBookmarked)
    }
    
    // MARK: - Configure

    public func configure(isBookmarked: Bool, countText: String?) {
        self.isBookmarked = isBookmarked
        updateIcon(isBookmarked: isBookmarked)

        if let countText, !countText.isEmpty {
            countLabel.isHidden = false
            countLabel.attributedText = .pretendard(.caption1_r_12, text: countText, color: .flintWhite)
        } else {
            countLabel.isHidden = true
            countLabel.attributedText = nil
        }
    }

}
