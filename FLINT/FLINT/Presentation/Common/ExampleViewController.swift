//
//  ExampleViewController.swift
//  FLINT
//
//  Created by 소은 on 1/9/26.
//

import UIKit

import SnapKit
import Then

final class ExampleViewController: BaseViewController {

    private let titleLabel = UILabel().then {
        $0.text = "Confirm Modal 테스트"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .label
    }

    private let openModalButton = UIButton(type: .system).then {
        $0.setTitle("삭제 모달 열기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 14
        $0.layer.cornerCurve = .continuous
    }

    override func setUI() {
        view.backgroundColor = .systemBackground
        openModalButton.addTarget(self, action: #selector(didTapOpenModal), for: .touchUpInside)
    }

    override func setHierarchy() {
        view.addSubviews(titleLabel, openModalButton)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        openModalButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }

    @objc private func didTapOpenModal() {
        let modal = FlintConfirmModalView(type: .deleteWork)

        modal.onCancel = {
            print("취소")
        }

        modal.onConfirm = {
            print("삭제")
        }

        modal.show(in: view)
    }
}
