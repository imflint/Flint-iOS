//
//  BaseBottomSheetViewController.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit

final class BaseBottomSheetViewController: BaseViewController {

    // MARK: - Input

    private let content: BottomSheetContent
    private let titleText: String?

    // MARK: - UI

    private let sheetView = BaseBottomSheetView()

    // MARK: - Init

    init(title: String? = nil, content: BottomSheetContent) {
        self.titleText = title
        self.content = content
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        show()
    }

    // MARK: - BaseViewController

    override func setUI() {
        view.backgroundColor = .clear

        sheetView.configure(title: titleText)

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
            let usersView = SavedUsersListView()
            usersView.configure(users: users)
            sheetView.setContentView(usersView)
        }

        sheetView.setNeedsLayout()
        sheetView.layoutIfNeeded()
    }

    override func setHierarchy() {
        view.addSubview(sheetView)
    }

    override func setLayout() {
        sheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.sheetView.dimView.alpha = 1
            self.sheetView.containerView.transform = .identity
        }
    }

    private func hide() {
        let height = calculateHeight()

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.sheetView.dimView.alpha = 0
            self.sheetView.containerView.transform = CGAffineTransform(translationX: 0, y: height)
        }) { _ in
            self.dismiss(animated: false)
        }
    }

    // MARK: - Height

    private func calculateHeight() -> CGFloat {
        let topPadding: CGFloat = 10 + 4
        let titlePadding: CGFloat = (titleText == nil) ? 0 : (20 + 16 + 20)
        let bottomPadding: CGFloat = 12

        switch content {
        case .ott(let platforms):
            let rowHeight: CGFloat = 48
            let spacing: CGFloat = 8
            let count = platforms.count
            let contentHeight = CGFloat(count) * rowHeight + CGFloat(max(count - 1, 0)) * spacing
            return topPadding + (titleText == nil ? 12 : 0) + titlePadding + contentHeight + bottomPadding

        case .savedUsers(let users):
            let rowHeight: CGFloat = 56
            let spacing: CGFloat = 8
            let count = users.count
            let contentHeight = CGFloat(count) * rowHeight + CGFloat(max(count - 1, 0)) * spacing
            return topPadding + (titleText == nil ? 12 : 0) + titlePadding + contentHeight + bottomPadding
        }
    }
}
