//
//  File.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import Foundation

protocol ToastQueueDelegate: AnyObject {
    
    func willShowAnyToast(_ toast: Toast, queuedToasts: [Toast]) -> Void
    
    func didShowAnyToast(_ toast: Toast, queuedToasts: [Toast]) -> Void
    
}

extension ToastQueueDelegate {
    
    func willShowAnyToast(toast: Toast, queuedToasts: [Toast]) {}
    
    func didShowAnyToast(toast: Toast, queuedToasts: [Toast]) {}
    
}
