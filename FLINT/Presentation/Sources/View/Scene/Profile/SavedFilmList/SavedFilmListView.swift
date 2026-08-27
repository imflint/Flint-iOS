//
//  SavedFilmListView.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import UIKit

import SnapKit
import Then

public final class SavedFilmListView: BaseView {

    // MARK: - UI

    public let searchTextField = UITextField().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 22
        $0.attributedPlaceholder = NSAttributedString(
            string: "작품을 검색해보세요",
            attributes: [
                .foregroundColor: UIColor.flintGray400,
                .font: UIFont.pretendard(.body2_r_14) ?? UIFont.systemFont(ofSize: 14)
            ]
        )
        $0.textColor = .flintWhite
        $0.font = .pretendard(.body2_r_14)
        $0.returnKeyType = .search
        $0.clearButtonMode = .whileEditing
        let leftPad = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        $0.leftView = leftPad
        $0.leftViewMode = .always
    }

    private let searchIconView = UIImageView().then {
        $0.image = UIImage(resource: .icSearch)
        $0.tintColor = .flintGray400
        $0.contentMode = .scaleAspectFit
    }

    public let countLabel = UILabel().then {
        $0.attributedText = .pretendard(.body2_r_14, text: "총 0개", color: .flintGray100)
    }

    public let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .flintBackground
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Setup

    public override func setUI() {
        backgroundColor = .flintBackground
    }

    public override func setHierarchy() {
        addSubviews(searchTextField, countLabel, tableView)
        searchTextField.addSubview(searchIconView)
    }

    public override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        searchIconView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        countLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
