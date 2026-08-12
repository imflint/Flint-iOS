//
//  CollectionFolderHeaderView.swift
//  Presentation
//
//  Created by 소은 on 8/12/26.
//

import UIKit
import SnapKit

public final class CollectionFolderHeaderView: UICollectionReusableView {
    
    public static let identifier = String(describing: CollectionFolderHeaderView.self)
    
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func configure(count: Int) {
        countLabel.attributedText = .pretendard(
            .body2_r_14,
            text: "총 \(count)개",
            color: DesignSystem.Color.gray100
        )
    }
}
