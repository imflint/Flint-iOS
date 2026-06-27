//
//  FlintCheckbox.swift
//  Presentation
//
//  Created by 김호성 on 2026.05.27.
//

import UIKit

package final class FlintCheckbox: UIButton {
    
    package init() {
        super.init(frame: .zero)
        
        setImage(.icCheckboxEmpty, for: .normal)
        setImage(.icCheckboxFill, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
