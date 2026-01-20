//
//  BaseTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/6/26.
//

import UIKit

public class BaseTableViewCell: UITableViewCell, ReuseIdentifiable {

    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    public override func prepareForReuse() {
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
    
    public func setStyle() { }
    public func setHierarchy() { }
    public func setLayout() { }
    public func prepare() { }
}
