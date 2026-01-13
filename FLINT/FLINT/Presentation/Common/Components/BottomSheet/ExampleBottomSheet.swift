//
//  ExampleBottomSheetViewController.swift
//  FLINT
//
//  Created by 소은 on 1/13/26.
//

import UIKit

import SnapKit

final class ExampleBottomSheetViewController: BaseViewController {

    // MARK: - UI

    private let openOTTButton = BasicButton(title: "OTT 바텀시트 열기")
    private let openSavedUsersButton = BasicButton(title: "저장한 사람들 바텀시트 열기")

    // MARK: - BaseViewController

    override func setUI() {
        view.backgroundColor = .flintBackground

        openOTTButton.addTarget(self, action: #selector(didTapOpenOTT), for: .touchUpInside)
        openSavedUsersButton.addTarget(self, action: #selector(didTapOpenSavedUsers), for: .touchUpInside)
    }

    override func setHierarchy() {
        view.addSubview(openOTTButton)
        view.addSubview(openSavedUsersButton)
    }

    override func setLayout() {
        openOTTButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        openSavedUsersButton.snp.makeConstraints {
            $0.top.equalTo(openOTTButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }

    // MARK: - Action

    @objc private func didTapOpenOTT() {
        let platforms = Array(OTTPlatform.allCases.prefix(3)) 
        let sheet = BaseBottomSheetViewController(
            title: nil,
            content: .ott(platforms: platforms)
        )
        present(sheet, animated: false)
    }

    @objc private func didTapOpenSavedUsers() {
        let users: [SavedUserRowItem] = [
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "키카", isVerified: true),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "닉네임", isVerified: true),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "안비", isVerified: false),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "오리너구리", isVerified: false),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "아이스티", isVerified: true),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "키카", isVerified: true),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "닉네임", isVerified: true),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "안비", isVerified: false),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "오리너구리", isVerified: false),
            .init(id: UUID(), profileImage: .imgProfileBlue, nickname: "아이스티", isVerified: true),
        ]
        let sheet = BaseBottomSheetViewController(
            title: "이 컬렉션을 저장한 사람들",
            content: .savedUsers(users: users)
        )
        present(sheet, animated: false)
    }
}
