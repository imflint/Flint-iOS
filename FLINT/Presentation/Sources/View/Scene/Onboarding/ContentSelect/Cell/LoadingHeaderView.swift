//
//  LoadingHeaderView.swift
//  Presentation
//
//  Created by 김호성 on 2026.05.02.
//

import UIKit

package final class LoadingHeaderView: UICollectionReusableView {
    
    private let loadingIndicator = UIActivityIndicatorView().configured {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.startAnimating()
    }
    
    package override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        addSubview(loadingIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            loadingIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
