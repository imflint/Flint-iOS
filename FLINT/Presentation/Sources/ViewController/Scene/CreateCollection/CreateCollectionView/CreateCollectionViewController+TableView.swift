//
//  CreateCollectionViewController+TableView.swift
//  Presentation
//
//  Created by 소은 on 8/13/26.
//

import UIKit
import Domain
import View
import ViewModel

extension CreateCollectionViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return CreateCollectionRow.allCases.count - 1
        } else {
            let hasButton = selectedReasonItems.count < 10
            return selectedReasonItems.count + 1 + (hasButton ? 1 : 0)
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let row = CreateCollectionRow(rawValue: indexPath.row) else { return UITableViewCell() }

            switch row {
            case .header:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionHeaderImageCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionHeaderImageCell
                if let headerImage {
                    cell.configure(with: headerImage)
                } else {
                    cell.configure(with: headerImageURL)
                }
                cell.onTapAddPhoto = { [weak self] in
                    guard let self else { return }
                    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    sheet.overrideUserInterfaceStyle = .dark

                    sheet.addAction(UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
                        self?.presentHeaderPhotoPicker()
                    })

                    sheet.addAction(UIAlertAction(title: "커버 사진 삭제", style: .destructive) { [weak self] _ in
                        guard let self else { return }
                        self.headerImage = nil
                        self.headerImageURL = nil
                        self.headerImageKey = nil
                        self.updateCreatePayload()
                        self.rootView.tableView.reloadRows(
                            at: [IndexPath(row: 0, section: 0)],
                            with: .none
                        )
                    })

                    sheet.addAction(UIAlertAction(title: "닫기", style: .cancel))
                    self.present(sheet, animated: true)
                }
                return cell

            case .title:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionTitleInputCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionTitleInputCell

                cell.onChangeTitle = { [weak self] text in
                    guard let self else { return }
                    self.collectionTitleText = text
                    self.updateCreatePayload()
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        cell.setError(false)
                    }
                }
                cell.setText(collectionTitleText)
                return cell

            case .description:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionDescriptionInputCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionDescriptionInputCell

                cell.onChangeDescription = { [weak self] text in
                    guard let self else { return }
                    self.collectionDescriptionText = text
                    self.updateCreatePayload()
                    self.rootView.tableView.beginUpdates()
                    self.rootView.tableView.endUpdates()
                }
                cell.setText(collectionDescriptionText)
                return cell

            case .visibility:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionVisibilityCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionVisibilityCell

                cell.configure(visibility: selectedVisibility)
                cell.onChangeVisibility = { [weak self] visibility in
                    guard let self else { return }
                    self.selectedVisibility = visibility
                    self.isPublic = (visibility == .public)
                    self.updateCreatePayload()
                    cell.setError(false)
                }
                return cell

            case .addContent:
                return UITableViewCell()
            }
        }

        if indexPath.section == 1 {

            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionAddContentHeaderCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionAddContentHeaderCell

                cell.configure(selectedCount: selectedReasonItems.count, maxCount: 10)
                return cell
            }

            let reasonIndex = indexPath.row - 1

            if reasonIndex < selectedReasonItems.count {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SelectedContentReasonTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as! SelectedContentReasonTableViewCell

                let item = selectedReasonItems[reasonIndex]
                cell.configure(with: item)

                cell.onTapClose = { [weak self, weak cell] in
                    guard let self, let cell,
                          let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                    let reasonIndex = indexPath.row - 1
                    let item = self.selectedReasonItems[reasonIndex]
                    self.deleteReasonItem(item, at: reasonIndex)
                }

                cell.onTapCloseWithDraft = { [weak self, weak cell] in
                    guard let self, let cell,
                          let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                    let reasonIndex = indexPath.row - 1
                    let item = self.selectedReasonItems[reasonIndex]
                    self.presentDeleteConfirmModal {
                        self.deleteReasonItem(item, at: reasonIndex)
                    }
                }

                cell.onToggleSpoiler = { [weak self, weak cell] isOn in
                    guard let self, let cell,
                          let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                    let reasonIndex = indexPath.row - 1
                    self.selectedReasonItems[reasonIndex].isSpoiler = isOn
                    self.updateCreatePayload()
                }

                cell.onChangeReasonText = { [weak self, weak cell] text in
                    guard let self, let cell,
                          let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                    let reasonIndex = indexPath.row - 1
                    self.selectedReasonItems[reasonIndex].reasonText = text
                    self.updateCreatePayload()
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        cell.setError(false)
                    }
                    self.rootView.tableView.beginUpdates()
                    self.rootView.tableView.endUpdates()
                }

                cell.onTapAddPhoto = { [weak self, weak cell] in
                    guard let self, let cell,
                          let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                    self.currentPhotoPickerIndex = indexPath.row - 1
                    self.presentPhotoPicker()
                }

                cell.onPhotosChanged = { [weak self, weak cell] in
                    guard let self, let cell,
                          let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                    let reasonIndex = indexPath.row - 1
                    self.selectedReasonItems[reasonIndex].photos = cell.currentPhotos
                    self.rootView.tableView.beginUpdates()
                    self.rootView.tableView.endUpdates()
                }

                return cell
            }

            guard selectedReasonItems.count < 10 else {
                return UITableViewCell()
            }

            let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateCollectionAddContentButtonCell.reuseIdentifier,
                for: indexPath
            ) as! CreateCollectionAddContentButtonCell

            cell.onTapAdd = { [weak self] in
                self?.presentAddContentSelect()
            }

            return cell
        }

        return UITableViewCell()
    }
}

extension CreateCollectionViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 0 { return 220 }
        return UITableView.automaticDimension
    }
}
