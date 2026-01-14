//
//  NicknameViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.12.
//

import PhotosUI
import UIKit

class NicknameViewController: BaseViewController {
    
    private let rootView = NicknameView()
    
    // MARK: - Basic
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        addActions()
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
        rootView.profileImageSettingView.profileImageView.image = .imgProfileGray
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
        let alert = UIAlertController(title: "앨범 접근 권한이 없습니다.", message: "설정으로 이동하시겠습니까?", preferredStyle: .alert)
        
        let selectAction = UIAlertAction(title: "설정으로 이동", style: .default, handler: openSettings(_:))
        let deleteAction = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(selectAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func openSettings(_ action: UIAlertAction) {
        if let openSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(openSettingsURL, options: [:], completionHandler: nil)
        }
    }
    
    private func verifyNickname(_ action: UIAction) {
        // TODO: - Verify Nickname Logic
        rootView.nextButton.isEnabled = true
    }
    
    private func nextButtonTapped(_ action: UIAction) {
        // TODO: - Next Button Tapped
    }
}

extension NicknameViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
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
