//
//  File.swift
//  
//
//  Created by Bas Jansen on 16/09/2023.
//

import Foundation

@MainActor
final class ToastQueue {
    
    private var queue: [Toast]
    private var multicast = MulticastDelegate<ToastQueueDelegate>()
    private var isShowing = false
    
    init(toasts: [Toast] = [], delegates: [ToastQueueDelegate] = []) {
        self.queue = toasts
        delegates.forEach(multicast.add)
    }
    
    func enqueue(_ toast: Toast) -> Void {
        queue.append(toast)
    }
    
    func enqueue(_ toasts: [Toast]) -> Void {
        let size = queue.count
        toasts.forEach({ queue.append($0) })
        
        if size == 0 && isShowing {
            show()
        }
    }
    
    func dequeue(_ toastToDequeue: Toast) -> Void {
        let index: Int? = queue.firstIndex { $0 === toastToDequeue }
        
        if let index {
            queue.remove(at: index)
        }
    }
    
    func size() -> Int {
        return queue.count
    }
    
    func show() -> Void {
        show(index: 0)
    }
    
    private func show(index: Int, after: Double = 0.0) -> Void {
        isShowing = true
        if queue.isEmpty {
            return
        }
        
        let toast: Toast = queue.remove(at: index)
        let delegate = QueuedToastDelegate(queue: self)
        
        multicast.invoke { $0.willShowAnyToast(toast, queuedToasts: queue) }
        
        toast.addDelegate(delegate: delegate)
        toast.show(after: after)
    }
    
    @MainActor
    private class QueuedToastDelegate: @MainActor ToastDelegate {
        
        private var queue: ToastQueue
        
        init(queue: ToastQueue) {
            self.queue = queue
        }
        
        func didCloseToast(_ toast: Toast) {
            queue.multicast.invoke { $0.didShowAnyToast(toast, queuedToasts: queue.queue) }
            queue.show(index: 0, after: 0.5)
        }
    }
}
