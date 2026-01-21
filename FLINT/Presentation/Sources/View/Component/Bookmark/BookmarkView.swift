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
    
    public var onTap: ((Bool, Int) -> Void)?
    
    private var isBookmarked: Bool = false
    private var count: Int = 0
    
    private let bookmarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage.icBookmarkEmpty.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let countLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    //MARK: - Setup
    
    public override func setUI() {
        addSubviews(bookmarkButton, countLabel)
        bookmarkButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        countLabel.isHidden = false
        updateIcon()
        updateCountLabel()
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
    
    private func updateIcon() {
        let image = isBookmarked ? UIImage.icBookmarkFill : UIImage.icBookmarkEmpty
        bookmarkButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func updateCountLabel() {
        countLabel.isHidden = false
        countLabel.attributedText = .pretendard(.caption1_r_12, text: "\(count)", color: .flintWhite)
    }
    
    @objc private func didTap() {
        let wasBookmarked = isBookmarked
        isBookmarked.toggle()
        
        if !wasBookmarked && isBookmarked {
            count += 1
        } else if wasBookmarked && !isBookmarked {
            count = max(0, count - 1)
        }
        
        updateIcon()
        updateCountLabel()
        onTap?(isBookmarked, count)
    }
    
    // MARK: - Configure

    public func configure(isBookmarked: Bool, countText: String? = "0") {
        self.isBookmarked = isBookmarked
        self.count = Int(countText ?? "") ?? 0
        
        if self.isBookmarked { self.count = max(1, self.count) }
        
        updateIcon()
        updateCountLabel()
    }
}
