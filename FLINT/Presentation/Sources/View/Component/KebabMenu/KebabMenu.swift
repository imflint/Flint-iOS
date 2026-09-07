//
//  KebabMenu.swift
//  FLINT
//
//  Created by 진소은 on 6/21/26.
//

import UIKit

import SnapKit
import Then

public struct KebabMenuItem {
    public let title: String
    public let titleColor: UIColor
    public let onTap: () -> Void

    public init(
        title: String,
        titleColor: UIColor = DesignSystem.Color.gray100,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.titleColor = titleColor
        self.onTap = onTap
    }
}

public final class KebabMenu: BaseView {

    // MARK: - Property

    private let items: [KebabMenuItem]

    // MARK: - Component

    private let dimView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let container = UIView().then {
        $0.backgroundColor = DesignSystem.Color.gray700
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }

    // MARK: - Init

    public init(items: [KebabMenuItem]) {
        self.items = items
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public override func setUI() {
        container.alpha = 0
    }

    public override func setHierarchy() {
        addSubviews(dimView, container)
        container.addSubview(stackView)

        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDim)))
        dimView.isUserInteractionEnabled = true

        for (index, item) in items.enumerated() {
            let button = makeItemButton(item: item)
            stackView.addArrangedSubview(button)

            if index < items.count - 1 {
                stackView.addArrangedSubview(makeSeparator())
            }
        }
    }

    public override func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Show / Dismiss

    /// 부모 뷰에 띄우고, 앵커 frame 우측 하단에 맞춰서 배치합니다.
    /// - Parameters:
    ///   - parent: 메뉴를 띄울 부모 뷰 (보통 VC의 root view)
    ///   - anchorFrame: 부모 뷰 좌표계 기준 앵커(=kebab 버튼) frame
    ///   - topOffset: 앵커 아래로 띄울 간격
    public func show(in parent: UIView, anchorFrame: CGRect, topOffset: CGFloat = 0) {
        parent.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }

        container.snp.makeConstraints {
            $0.top.equalTo(parent.snp.top).offset(anchorFrame.maxY + topOffset)
            $0.trailing.equalTo(parent.snp.leading).offset(anchorFrame.maxX)
        }

        parent.layoutIfNeeded()

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut]) {
            self.container.alpha = 1
        }
    }

    public func dismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) {
            self.container.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }

    // MARK: - Factory

    private func makeItemButton(item: KebabMenuItem) -> UIControl {
        let control = ItemControl().then {
            $0.backgroundColor = DesignSystem.Color.gray700
        }
        let label = UILabel().then {
            $0.attributedText = .pretendard(.body1_m_16, text: item.title, color: item.titleColor, alignment: .center)
            $0.isUserInteractionEnabled = false
        }
        control.addSubview(label)
        control.snp.makeConstraints {
            $0.width.equalTo(104)
            $0.height.equalTo(48)
        }
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        control.addAction(UIAction { [weak self] _ in
            self?.dismiss { item.onTap() }
        }, for: .touchUpInside)
        return control
    }

    private func makeSeparator() -> UIView {
        let line = UIView()
        line.backgroundColor = DesignSystem.Color.gray400
        line.snp.makeConstraints { $0.height.equalTo(1) }
        return line
    }

    // MARK: - Action

    @objc private func didTapDim() {
        dismiss()
    }
}

// MARK: - ItemControl

/// Highlight feedback을 위한 단순 UIControl 래퍼.
private final class ItemControl: UIControl {
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1.0
        }
    }
}
