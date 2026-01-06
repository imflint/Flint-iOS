//
//  BaseTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare()
    }

    // MARK: - Template Method
    
    private func setup() {
        selectionStyle = .none
        setHierarchy()
        setLayout()
        setStyle()
    }

    // MARK: - Override Points
    
    func setStyle() { }
    func setHierarchy() { }
    func setLayout() { }
    func prepare() { }
}
