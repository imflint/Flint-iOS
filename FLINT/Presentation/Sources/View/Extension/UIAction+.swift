//
//  UIAction+.swift
//  Presentation
//
//  Created by 루미씨티 on 4/14/26.
//

import UIKit

extension UIAction {
    public convenience init<T: AnyObject>(
        weak target: T,
        handler: @escaping @Sendable (T) -> @Sendable (UIAction) -> Void
    ) {
        self.init { [weak target] action in
            guard let target else { return }
            handler(target)(action)
        }
    }
}
