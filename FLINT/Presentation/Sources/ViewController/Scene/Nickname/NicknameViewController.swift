//
//  NicknameViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import Combine
import PhotosUI
import UIKit

import Domain

import View
import ViewModel

public final class NicknameViewController: BaseViewController<NicknameView> {
    
    // MARK: - ViewModel
    
    private let onboardingViewModel: OnboardingViewModel
    
    // MARK: - Basic
    
    public init(onboardingViewModel: OnboardingViewModel, viewControllerFactory: ViewControllerFactory) {
        self.onboardingViewModel = onboardingViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(left: .back))
        hideKeyboardWhenTappedAround()
        addActions()
    }
    
    // MARK: - Bind
    
    public override func bind() {
        onboardingViewModel.nicknameValidState.sink(receiveValue: { [weak self] nicknameValidState in
            Log.d(nicknameValidState)
            guard let self else { return }
            switch nicknameValidState {
            case .valid:
                rootView.nextButton.isEnabled = true
                rootView.nicknameWarningLabel.isHidden = true
                rootView.nicknameTextField.layer.borderWidth = 0
                rootView.nicknameTextField.layer.borderColor = nil
                Toast.success("사용 가능한 닉네임입니다", customConstraints: {
                    $0.bottom.equalTo(self.rootView.nextButton.snp.top).offset(-8)
                }).show()
            case .invalid:
                rootView.nextButton.isEnabled = false
                rootView.nicknameWarningLabel.isHidden = false
                rootView.nicknameTextField.layer.borderWidth = 1
                rootView.nicknameTextField.layer.borderColor = DesignSystem.Color.error500.cgColor
            case .duplicate:
                rootView.nextButton.isEnabled = false
                rootView.nicknameWarningLabel.isHidden = true
                rootView.nicknameTextField.layer.borderWidth = 1
                rootView.nicknameTextField.layer.borderColor = DesignSystem.Color.error500.cgColor
                Toast.failure("이미 사용 중인 닉네임입니다", customConstraints: {
                    $0.bottom.equalTo(self.rootView.nextButton.snp.top).offset(-8)
                }).show()
            case .none:
                rootView.nextButton.isEnabled = false
                rootView.nicknameWarningLabel.isHidden = true
                rootView.nicknameTextField.layer.borderWidth = 0
                rootView.nicknameTextField.layer.borderColor = nil
            }
        })
        .store(in: &cancellables)
    }
    
    // MARK: - Private Function
    
    private func addActions() {
        rootView.profileImageSettingView.settingButton.addAction(UIAction(handler: showProfileImageSettingAlert(_:)), for: .touchUpInside)
        rootView.verifyButton.addAction(UIAction(handler: verifyNickname(_:)), for: .touchUpInside)
        rootView.nextButton.addAction(UIAction(handler: nextButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func showProfileImageSettingAlert(_ action: UIAction) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let selectAction = UIAlertAction(title: "앨범에서 선택", style: .default, handler: selectPhotoFromAlbum(_:))
        let deleteAction = UIAlertAction(title: "프로필 사진 삭제", style: .destructive, handler: deleteProfileImage(_:))
        let closeAction = UIAlertAction(title: "닫기", style: .cancel)
        
        alert.addAction(selectAction)
        alert.addAction(deleteAction)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
    
    private func selectPhotoFromAlbum(_ action: UIAlertAction) {
        getAlbumAuthorization()
    }
    
    private func deleteProfileImage(_ action: UIAlertAction) {
        rootView.profileImageSettingView.profileImageView.image = DesignSystem.Image.Common.profileGray
    }
    
    private func getAlbumAuthorization() {
        let authStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { [weak self] status in
                if status == .authorized, status == .limited {
                    self?.presentPicker()
                }
            })
        case .denied, .restricted:
            presentAuthAlert()
        case .authorized:
            presentPicker()
        case .limited:
            presentPicker()
        @unknown default:
            Log.e("Unknown Album Authorization Status: \(authStatus)")
        }
    }
    
    private func presentPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        
        present(pickerViewController, animated: true)
    }
    
    private func presentAuthAlert() {
        let alert = UIAlertController(title: "앨범 접근 권한이 없습니다.", message: "설정에서 Flint의 사진 접근 권한을 허용해 주세요.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "취소", style: .destructive)
        let selectAction = UIAlertAction(title: "설정으로 이동", style: .default, handler: openSettings(_:))
        
        alert.addAction(deleteAction)
        alert.addAction(selectAction)
        
        present(alert, animated: true)
    }
    
    private func openSettings(_ action: UIAlertAction) {
        if let openSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(openSettingsURL, options: [:], completionHandler: nil)
        }
    }
    
    private func verifyNickname(_ action: UIAction) {
        guard let nickname = rootView.nicknameTextField.text else { return }
        onboardingViewModel.checkNickname(nickname)
    }
    
    private func nextButtonTapped(_ action: UIAction) {
        guard let filmSelectViewController = viewControllerFactory?.makeFilmSelectViewController(onboardingViewModel: onboardingViewModel) else { return }
        navigationController?.pushViewController(filmSelectViewController, animated: true)
    }
}

extension NicknameViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.map(\.itemProvider).first else {
            Log.e("[PHPickerResult] is empty.")
            return
        }
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            Log.e("Can't load UIImage from itemProvider.")
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self, let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.rootView.profileImageSettingView.profileImageView.image = image
            }
        }
    }
}
