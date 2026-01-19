//
//  BaseBottomSheetViewController.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit

public final class BaseBottomSheetViewController: UIViewController {
    
    private let content: BottomSheetContent
    private let titleText: String?
    private let titleCount: Int?
    
    // MARK: - UI
    
    private let sheetView = BaseBottomSheetView()
    
    // MARK: - Init
    
    public init(title: String? = nil, count: Int? = nil, content: BottomSheetContent) {
        self.titleText = title
        self.titleCount = count
        self.content = content
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUI()
        setHierarchy()
        setLayout()
        
        show()
    }
    
    // MARK: - Setup
    
    private func setUI() {
        view.backgroundColor = .clear
        
        let resolvedCount: Int? = {
            if let titleCount { return titleCount }
            if case .savedUsers(let users) = content { return users.count }
            return nil
        }()

        sheetView.configure(title: titleText, count: resolvedCount)
        
        sheetView.onTapDim = { [weak self] in
            self?.hide()
        }
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        switch content {
        case .ott(let platforms):
            let ottListView = OTTListView()
            ottListView.configure(platforms: platforms)
            ottListView.onSelectPlatform = { platform in
                UIApplication.shared.open(platform.webURL)
            }
            sheetView.setContentView(ottListView)
            
        case .savedUsers(let users):
            let usersView = SavedUserListView()
            usersView.configure(users: users)
            sheetView.setContentView(usersView)
        }
        
        sheetView.setNeedsLayout()
        sheetView.layoutIfNeeded()
    }
    
    private func setHierarchy() {
        view.addSubview(sheetView)
    }
    
    private func setLayout() {
        sheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        let height = calculateHeight()
        sheetView.containerView.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
    
    // MARK: - Action
    
    @objc private func didSwipeDown() {
        hide()
    }
    
    // MARK: - Show / Hide
    
    private func show() {
        let height = calculateHeight()
        sheetView.containerView.transform = CGAffineTransform(translationX: 0, y: height)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut) {
            self.sheetView.dimView.alpha = 1
            self.sheetView.containerView.transform = .identity
        }
    }
    
    private func hide() {
        let height = calculateHeight()
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            self.sheetView.dimView.alpha = 0
            self.sheetView.containerView.transform = CGAffineTransform(translationX: 0, y: height)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: - Height
    
    private func calculateHeight() -> CGFloat {
        let grabberTop: CGFloat = 12
        let grabberHeight: CGFloat = 4
        let bottomPadding: CGFloat = 32

        let hasTitle = (titleText != nil)

        let titleHeight: CGFloat = hasTitle ? UIFont.PretendardStyle.head3_sb_18.lineHeight : 0
        let titleAreaHeight: CGFloat = hasTitle
            ? (12 + titleHeight + 16): 12

        switch content {
        case .ott(let platforms):
            let rowHeight: CGFloat = 48
            let spacing: CGFloat = 8
            let count = platforms.count
            let contentHeight = CGFloat(count) * rowHeight + CGFloat(max(count - 1, 0)) * spacing
            return grabberTop + grabberHeight + titleAreaHeight + contentHeight + bottomPadding

       
        case .savedUsers(let users):
            let rowHeight: CGFloat = 44
            let spacing: CGFloat = 8

            let visibleCount = min(users.count, 9)
            let contentHeight = CGFloat(visibleCount) * rowHeight
                + CGFloat(max(visibleCount - 1, 0)) * spacing

            return grabberTop + grabberHeight + titleAreaHeight + contentHeight + bottomPadding
        }
    }
}
