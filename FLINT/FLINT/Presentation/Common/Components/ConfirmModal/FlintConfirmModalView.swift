//
//  FlintConfirmModalView.swift
//  FLINT
//
//  Created by 소은 on 1/9/26.
//

import UIKit

import SnapKit
import Then

// MARK: - FlintConfirmModalView

final class FlintConfirmModalView: BaseView {

    // MARK: - UI Components

    private let dimView = UIView().then {
        $0.backgroundColor = .flintOverlay
        $0.alpha = 0
    }

    private let containerView = UIView().then {
        $0.alpha = 0
        $0.layer.cornerRadius = 12
        $0.layer.cornerCurve = .continuous
        $0.clipsToBounds = true
    }

    private let backgroundView = GradientView()

    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 0
    }

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textColor = .flintWhite
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }

    private let cancelButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor.flintGray100
        $0.setTitleColor(.flintBackground, for: .normal)
        $0.layer.cornerRadius = 12
        $0.layer.cornerCurve = .continuous
    }

    private let confirmButton = UIButton(type: .system).then {
        $0.setTitleColor(.flintWhite, for: .normal)
        $0.layer.cornerRadius = 12
        $0.layer.cornerCurve = .continuous
    }

    private let spacerView = UIView()

    // MARK: - Properties

    private let type: ConfirmModalType

    var onCancel: (() -> Void)?
    var onConfirm: (() -> Void)?

    // MARK: - Init

    init(type: ConfirmModalType) {
        self.type = type
        super.init(frame: .zero)
        apply(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func setUI() {
        backgroundColor = .clear

        let dimTap = UITapGestureRecognizer(target: self, action: #selector(didTapDim))
        dimView.addGestureRecognizer(dimTap)

        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
    }

    override func setHierarchy() {
        addSubviews(dimView, containerView)

        containerView.addSubview(backgroundView)
        containerView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(buttonStackView)
        contentStackView.addArrangedSubview(spacerView)

        contentStackView.setCustomSpacing(12, after: iconImageView)
        contentStackView.setCustomSpacing(32, after: titleLabel)

        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)

        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }

    override func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(328)
        }

        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(18)
        }

        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(88)
        }

        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
        }
    }

    // MARK: - Public

    func show(in parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        parentView.layoutIfNeeded()
        animateShow()
    }

    func dismiss(completion: (() -> Void)? = nil) {
        animateDismiss(completion: completion)
    }

    // MARK: - Private

    private func apply(type: ConfirmModalType) {
        iconImageView.image = type.icon

        titleLabel.attributedText = .pretendard(.body1_b_16, text: type.title, alignment: .center)

        cancelButton.setAttributedTitle(.pretendard(.body1_b_16, text: type.cancelTitle), for: .normal)

        confirmButton.setAttributedTitle(.pretendard(.body1_b_16, text: type.confirmTitle), for: .normal)
        confirmButton.backgroundColor = type.confirmButtonColor
    }

    private func animateShow() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut]) {
            self.dimView.alpha = 1
            self.containerView.alpha = 1
        }
    }

    private func animateDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseIn]) {
            self.dimView.alpha = 0
            self.containerView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }

    // MARK: - Actions

    @objc private func didTapDim() {
        onCancel?()
        dismiss()
    }

    @objc private func didTapCancel() {
        onCancel?()
        dismiss()
    }

    @objc private func didTapConfirm() {
        onConfirm?()
        dismiss()
    }
}
