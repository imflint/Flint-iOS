//
//  AddContentSelectView.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

public final class AddContentSelectView: BaseView {

    // MARK: - UI

    public let searchTextField = SearchTextField(placeholder: "추천하고 싶은 작품을 검색해보세요")

    private let selectedPreviewContainerView = UIView().then {
        $0.backgroundColor = .flintBackground
        $0.clipsToBounds = false
    }

    public let selectedPreviewCollectionView = UICollectionView(
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
        $0.clipsToBounds = true
    }

    public let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }

    public let emptyView = EmptyStateView(type: .notFoundWork).then {
        $0.isHidden = false
    }

    // MARK: - BaseView

    public override func setUI() {
        backgroundColor = .flintBackground
    }

    public override func setHierarchy() {
        addSubviews(searchTextField, selectedPreviewContainerView, tableView, emptyView)
        selectedPreviewContainerView.addSubview(selectedPreviewCollectionView)
    }

    public override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        selectedPreviewContainerView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(108)
        }

        selectedPreviewCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(selectedPreviewContainerView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        bringSubviewToFront(selectedPreviewContainerView)

        selectedPreviewContainerView.layer.applyShadow(
            alpha: 0.25,
            blur: 12,
            spread: 0,
            x: 0,
            y: 12,
            cornerRadius: 0
        )
    }

    // MARK: - Public

    public func setPreviewHidden(_ hidden: Bool) {
        selectedPreviewContainerView.isHidden = hidden

        tableView.snp.remakeConstraints {
            if hidden {
                $0.top.equalTo(searchTextField.snp.bottom).offset(24)
            } else {
                $0.top.equalTo(selectedPreviewContainerView.snp.bottom).offset(8)
            }
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    public func setEmptyHidden(_ hidden: Bool) {
        emptyView.isHidden = hidden
        tableView.isHidden = !hidden
    }
    
}
