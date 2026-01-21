//
//  ToggleBarView.swift
//  FLINT
//
//  Created by 소은 on 1/8/26.
//

import UIKit

import SnapKit
import Then

// MARK: - ToggleBarView

public final class ToggleBarView: BaseView {

    // MARK: - UI Components

    private var knobLeadingConstraint: Constraint?

    private let trackView = UIView().then {
        $0.clipsToBounds = true
    }

    private let knobView = UIView().then {
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 6
    }

    // MARK: - Properties

    private var type: ToggleBarType
    private var isOn: Bool

    private let knobSize: CGFloat
    private let contentInset: CGFloat

    public var onValueChanged: ((Bool) -> Void)?

    // MARK: - Init

    public init(
        type: ToggleBarType = .primary,
        isOn: Bool = false,
        knobSize: CGFloat = 24,
        contentInset: CGFloat = 3
    ) {
        self.type = type
        self.isOn = isOn
        self.knobSize = knobSize
        self.contentInset = contentInset
        super.init(frame: .zero)
        apply(type: type)
        apply(isOn: isOn, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    public override func setUI() {
        backgroundColor = .clear

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }

    public override func setHierarchy() {
        addSubview(trackView)
        trackView.addSubview(knobView)
    }

    public override func setLayout() {
        trackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        knobView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(knobSize)
            knobLeadingConstraint = $0.leading.equalToSuperview().offset(contentInset).constraint
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        trackView.layer.cornerRadius = trackView.bounds.height / 2
        trackView.layer.borderWidth = type.borderColor == .clear ? 0 : 1
        trackView.layer.borderColor = type.borderColor.cgColor

        knobView.layer.cornerRadius = knobSize / 2
        knobView.layer.shadowColor = type.shadowColor.cgColor
        knobView.layer.shadowPath = UIBezierPath(
            roundedRect: knobView.bounds,
            cornerRadius: knobView.layer.cornerRadius
        ).cgPath

        updateKnobPosition(animated: false)
    }

    // MARK: - Actions

    @objc private func didTap() {
        setOn(!isOn, animated: true, sendEvent: true)
    }

    // MARK: - Public

    public func apply(type: ToggleBarType) {
        self.type = type
        knobView.backgroundColor = type.knobColor
        updateTrackColor()
        setNeedsLayout()
    }

    public func setOn(_ isOn: Bool, animated: Bool, sendEvent: Bool = false) {
        self.isOn = isOn
        updateTrackColor()
        updateKnobPosition(animated: animated)

        if sendEvent {
            onValueChanged?(isOn)
        }
    }

    // MARK: - Private

    private func apply(isOn: Bool, animated: Bool) {
        self.isOn = isOn
        updateTrackColor()
        updateKnobPosition(animated: animated)
    }

    private func updateTrackColor() {
        trackView.backgroundColor = isOn ? type.onTrackColor : type.offTrackColor
    }

    private func updateKnobPosition(animated: Bool) {
        let left = contentInset
        let right = max(contentInset, trackView.bounds.width - knobSize - contentInset)
        let target = isOn ? right : left

        knobLeadingConstraint?.update(offset: target)

        if animated {
            UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut]) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
}
