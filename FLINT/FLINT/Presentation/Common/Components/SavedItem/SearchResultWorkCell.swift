//
//  SearchResultWorkCell.swift
//  FLINT
//
//  Created by 소은 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class SearchResultWorkCell: UICollectionViewCell {

    static let reuseIdentifier = "SearchResultWorkCell"

    private let itemView = SavedContentItemView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemView)

        itemView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(model: SavedContentItemView.ViewModel, mode: SavedContentItemView.Mode) {
        itemView.configure(model: model, mode: mode)
    }
}
