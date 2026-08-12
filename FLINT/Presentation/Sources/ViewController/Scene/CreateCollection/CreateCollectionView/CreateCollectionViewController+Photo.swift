//
//  CreateCollectionViewController+Photo.swift
//  Presentation
//
//  Created by 소은 on 8/13/26.
//

import UIKit
import PhotosUI
import View
import ViewModel

extension CreateCollectionViewController: PHPickerViewControllerDelegate {

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let index = currentPhotoPickerIndex else { return }

        Task { @MainActor in
            let images = await self.loadImages(from: results)
            guard let image = images.first else { return }

            if index == -1 {
                viewModel.uploadImages([image])
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                print("헤더 이미지 업로드 실패:", error)
                            }
                        },
                        receiveValue: { [weak self] keys in
                            guard let self else { return }
                            self.headerImage = image
                            self.headerImageURL = nil
                            self.headerImageKey = keys.first
                            self.rootView.tableView.reloadRows(
                                at: [IndexPath(row: 0, section: 0)],
                                with: .none
                            )
                        }
                    )
                    .store(in: &cancellables)
                return
            }

            viewModel.uploadImages(images)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("이미지 업로드 실패:", error)
                        }
                    },
                    receiveValue: { [weak self] keys in
                        guard let self else { return }
                        if let cell = self.rootView.tableView.cellForRow(
                            at: IndexPath(row: index + 1, section: 1)
                        ) as? SelectedContentReasonTableViewCell {
                            self.selectedReasonItems[index].reasonText = cell.currentReasonText
                        }
                        let existingPhotos = self.selectedReasonItems[index].photos
                        let existingKeys = self.selectedReasonItems[index].customImageKeys
                        self.selectedReasonItems[index].photos = existingPhotos + images
                        self.selectedReasonItems[index].customImageKeys = existingKeys + keys
                        self.rootView.tableView.reloadRows(
                            at: [IndexPath(row: index + 1, section: 1)],
                            with: .none
                        )
                    }
                )
                .store(in: &cancellables)
        }
    }

    func presentPhotoPicker() {
        let currentCount = currentPhotoPickerIndex.flatMap { idx in
            idx >= 0 ? selectedReasonItems[safe: idx]?.photos.count : nil
        } ?? 0
        let remaining = max(0, 5 - currentCount)
        guard remaining > 0 else { return }

        var config = PHPickerConfiguration()
        config.selectionLimit = remaining
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func presentHeaderPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        currentPhotoPickerIndex = -1
        present(picker, animated: true)
    }

    func loadImages(from results: [PHPickerResult]) async -> [UIImage] {
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, result) in results.enumerated() {
                group.addTask {
                    await withCheckedContinuation { continuation in
                        result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                            continuation.resume(returning: (index, object as? UIImage))
                        }
                    }
                }
            }

            var indexedImages: [(Int, UIImage)] = []
            for await (index, image) in group {
                if let image = image {
                    indexedImages.append((index, image))
                }
            }

            return indexedImages
                .sorted { $0.0 < $1.0 }
                .map { $0.1 }
        }
    }
}
