//
//  OTTBottomSheetViewController.swift
//  FLINT
//
//  Created by 소은 on 1/12/26.
//

import UIKit

import SnapKit
import Then

final class OTTBottomSheetViewController: BaseViewController {

    private let platforms: [OTTPlatform]

    private let rowHeight: CGFloat = 48
    private let rowSpacing: CGFloat = 8
    private let sheetTopInset: CGFloat = 36
    private let sheetBottomInset: CGFloat = 12
    
    // MARK: - UI

    private let dimView = UIView().then {
        $0.backgroundColor = .flintOverlay
        $0.alpha = 0
    }

    private let containerView = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private var sheetHeight: CGFloat {
        let count = platforms.count
        let rowsHeight = CGFloat(count) * rowHeight
        let spacingsHeight = CGFloat(max(count - 1, 0)) * rowSpacing
        return sheetTopInset + rowsHeight + spacingsHeight + sheetBottomInset
    }


    private let grabberView = UIView().then {
        $0.backgroundColor = .flintGray500
        $0.layer.cornerRadius = 4
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }

    // MARK: - Init

    init(platforms: [OTTPlatform] = OTTPlatform.allCases) {
        self.platforms = platforms
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
       
    }

    // MARK: - BaseViewController

    override func setUI() {

        platforms.forEach { platform in
            let row = OTTPlatformRowView()
            row.configure(platform: platform)
            row.onTapOpen = { [weak self] in
                self?.open(platform: platform)
            }
            stackView.addArrangedSubview(row)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDim))
        dimView.addGestureRecognizer(tap)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapDim))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    override func setHierarchy() {
        view.addSubview(dimView)
        view.addSubview(containerView)

        containerView.addSubview(grabberView)
        containerView.addSubview(stackView)
    }

    override func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(sheetHeight)
        }

        grabberView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(52)
            $0.height.equalTo(4)
        }

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    // MARK: - Action

    @objc private func didTapDim() {
        hideBottomSheet()
    }

    // MARK: - Animation
    
    func showBottomSheet() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 1

            self.containerView.snp.remakeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(self.sheetHeight)
                $0.top.equalToSuperview().inset(self.view.frame.height - self.sheetHeight)
            }

            self.view.layoutIfNeeded()
        })
    }

    func hideBottomSheet() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 0

            self.containerView.snp.remakeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(self.sheetHeight)
                $0.top.equalToSuperview().inset(self.view.frame.height)
            }

            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }

    // MARK: - Open URL

    private func open(platform: OTTPlatform) {
        UIApplication.shared.open(platform.webURL)
    }
}


