//
//  Toast.swift
//  Toast
//
//  Created by Bastiaan Jansen on 27/06/2021.
//

import UIKit

public class Toast {
    private static var activeToasts: [Toast] = []
    
    public let view: ToastView
    private var backgroundView: UIView?
    
    private var closeTimer: Timer?
    
    /// This is for pan gesture to close.
    private var startY: CGFloat = 0
    private var startShiftY: CGFloat = 0

    private var multicast = MulticastDelegate<ToastDelegate>()
    
    public private(set) var config: ToastConfiguration
    
    public static func success(
        _ text: String,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        return `default`(image: .icCheck, title: text)
    }
    
    public static func failure(
        _ text: String,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        return `default`(image: .icX, title: text)
    }
    
    /// Creates a new Toast with the default Apple style layout with an icon, title and optional subtitle.
    /// - Parameters:
    ///   - image: Image which is displayed in the toast view
    ///   - imageTint: Tint of the image
    ///   - title: Attributed title which is displayed in the toast view
    ///   - subtitle: Optional attributed subtitle which is displayed in the toast view
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public static func `default`(
        image: UIImage? = nil,
        title: String,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        let view = FlintToastView(child: ToastContentsView(image: image, title: title))
        return self.init(view: view, config: config)
    }
    
    /// Creates a new Toast with a custom view
    /// - Parameters:
    ///   - view: A view which is displayed when the toast is shown
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public static func custom(
        view: ToastView,
        config: ToastConfiguration = ToastConfiguration()
    ) -> Toast {
        return self.init(view: view, config: config)
    }
    
    /// Creates a new Toast with a custom view
    /// - Parameters:
    ///   - view: A view which is displayed when the toast is shown
    ///   - config: Configuration options
    /// - Returns: A new Toast view with the configured layout
    public required init(view: ToastView, config: ToastConfiguration) {
        self.config = config
        self.view = view
        
        for dismissable in config.dismissables {
            switch dismissable {
            case .tap:
                enableTapToClose()
            case .longPress:
                enableLongPressToClose()
            case .swipe:
                enablePanToClose()
            default:
                break
            }
        }
    }
    
    /// Show the toast with haptic feedback
    /// - Parameters:
    ///   - type: Haptic feedback type
    ///   - time: Time after which the toast is shown
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        show(after: time)
    }
    
    /// Show the toast
    /// - Parameter delay: Time after which the toast is shown
    public func show(after delay: TimeInterval = 0) {
        UIView.performWithoutAnimation {
            config.view?.addSubview(view) ?? ToastHelper.topController()?.view.addSubview(view)
            view.createView(for: self)
            view.layoutIfNeeded()
        }
        
        multicast.invoke { $0.willShowToast(self) }

        config.enteringAnimation.apply(to: self.view)
        let endBackgroundColor = backgroundView?.backgroundColor
        backgroundView?.backgroundColor = .clear
        UIView.animate(withDuration: config.animationTime, delay: delay, options: [.curveEaseOut, .allowUserInteraction]) {
            self.config.enteringAnimation.undo(from: self.view)
            self.backgroundView?.backgroundColor = endBackgroundColor
        } completion: { [self] _ in
            multicast.invoke { $0.didShowToast(self) }
            
            configureCloseTimer()
            if !config.allowToastOverlap {
                closeOverlappedToasts()
            }
            Toast.activeToasts.append(self)
        }
    }
    
    private func closeOverlappedToasts() {
        Toast.activeToasts.forEach {
            $0.closeTimer?.invalidate()
            $0.close(animated: false)
        }
    }
    
    /// Close the toast
    /// - Parameters:
    ///   - completion: A completion handler which is invoked after the toast is hidden
    ///   - animated: A Boolean value that determines whether to apply animation.
    public func close(animated: Bool = true, completion: (() -> Void)? = nil) {
        multicast.invoke { $0.willCloseToast(self) }

        closeTimer?.invalidate()
        
        UIView.animate(withDuration: config.animationTime,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
            if animated {
                self.config.exitingAnimation.apply(to: self.view)
            }
            self.backgroundView?.backgroundColor = .clear
        }, completion: { _ in
            self.backgroundView?.removeFromSuperview()
            self.view.removeFromSuperview()
            if let index = Toast.activeToasts.firstIndex(where: { $0 == self }) {
                Toast.activeToasts.remove(at: index)
            }
            completion?()
            self.multicast.invoke { $0.didCloseToast(self) }
        })
    }
    
    public func addDelegate(delegate: ToastDelegate) -> Void {
        multicast.add(delegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension Toast {
    private func enablePanToClose() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(toastOnPan(_:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc private func toastOnPan(_ gesture: UIPanGestureRecognizer) {
        guard let topVc = ToastHelper.topController() else {
            return
        }
        
        switch gesture.state {
        case .began:
            startY = self.view.frame.origin.y
            startShiftY = gesture.location(in: topVc.view).y
            closeTimer?.invalidate()
        case .changed:
            let delta = gesture.location(in: topVc.view).y - startShiftY
            
            for dismissable in config.dismissables {
                if case .swipe(let dismissSwipeDirection) = dismissable {
                    let shouldApply = dismissSwipeDirection.shouldApply(delta, direction: config.direction)
                    
                    if shouldApply {
                        self.view.frame.origin.y = startY + delta
                    }
                }
            }
            
        case .ended:
            let threshold = 15.0 // if user drags more than threshold the toast will be dismissed
            let ammountOfUserDragged = abs(startY - self.view.frame.origin.y)
            let shouldDismissToast = ammountOfUserDragged > threshold
            
            if shouldDismissToast {
                close()
            } else {
                UIView.animate(withDuration: config.animationTime, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                    self.view.frame.origin.y = self.startY
                } completion: { [self] _ in
                    configureCloseTimer()
                }
            }
            
        case .cancelled, .failed:
            configureCloseTimer()
        default:
            break
        }
    }
    
    func enableTapToClose() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toastOnTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func enableLongPressToClose() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(toastOnTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func toastOnTap(_ gesture: UITapGestureRecognizer) {
        closeTimer?.invalidate()
        close()
    }
    
    private func configureCloseTimer() {
        for dismissable in config.dismissables {
            if case .time(let displayTime) = dismissable {
                closeTimer = Timer.scheduledTimer(withTimeInterval: .init(displayTime), repeats: false) { [self] _ in
                    close()
                }
            }
        }
    }
}

extension Toast {
    public enum Dismissable: Equatable {
        case tap,
             longPress,
             time(time: TimeInterval),
             swipe(direction: DismissSwipeDirection)
    }
}

extension Toast: Equatable {
    public static func == (lhs: Toast, rhs: Toast) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
