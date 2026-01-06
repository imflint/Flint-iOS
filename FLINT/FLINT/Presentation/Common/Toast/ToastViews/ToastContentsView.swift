//
//  DefaultToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 29/06/2021.
//

import UIKit

import Then

public class ToastContentsView : UIStackView {
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            $0.widthAnchor.constraint(equalToConstant: 16),
            $0.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.applyFontStyle(.body2_r_14)
        $0.textColor = .flintWhite
    }
    
    public init(image: UIImage? = nil, title: String) {
        super.init(frame: .zero)
        commonInit()
        
        self.titleLabel.text = title
        self.imageView.image = image
        
        if image != nil {
            addArrangedSubview(self.imageView)
        }
        addArrangedSubview(self.titleLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        axis = .horizontal
        alignment = .center
        spacing = 8
        distribution = .fill
    }
}
