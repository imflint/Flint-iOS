//
//  AddContentSelectView.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class AddContentSelectView: BaseView {

    // MARK: - UI
    
    let searchTextField = SearchTextField(placeholder: "추천하고 싶은 작품을 검색해보세요")

    let selectedPreviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 92, height: 92)
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
        }
    ).then {
        $0.backgroundColor = .flintBackground
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(FilmPreviewCollectionViewCell.self)
    }

    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }

    let emptyView = EmptyStateView(type: .notFoundWork).then {
        $0.isHidden = false
    }

    // MARK: - BaseView

    override func setUI() {
        backgroundColor = .flintBackground
    }

    override func setHierarchy() {
        addSubviews(searchTextField, selectedPreviewCollectionView, tableView, emptyView)
    }

    override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        selectedPreviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(108)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(selectedPreviewCollectionView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Public

    func setPreviewHidden(_ hidden: Bool) {
        selectedPreviewCollectionView.isHidden = hidden

        tableView.snp.remakeConstraints {
            if hidden {
                $0.top.equalTo(searchTextField.snp.bottom).offset(12)
            } else {
                $0.top.equalTo(selectedPreviewCollectionView.snp.bottom).offset(8)
            }
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func setEmptyHidden(_ hidden: Bool) {
        emptyView.isHidden = hidden
        tableView.isHidden = !hidden
    }
}
