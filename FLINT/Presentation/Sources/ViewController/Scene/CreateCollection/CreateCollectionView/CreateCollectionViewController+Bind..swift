//
//  CreateCollectionViewController+Bind..swift
//  Presentation
//
//  Created by 소은 on 8/13/26.
//

import UIKit
import Domain
import View
import ViewModel

extension CreateCollectionViewController {

    func replaceCurrentFlowWithDetail(_ detailVC: UIViewController) {
        guard let nav = self.navigationController else { return }
        var stack = nav.viewControllers
        if let idx = stack.lastIndex(where: { $0 === self }) {
            stack.removeSubrange(idx..<stack.count)
        }
        if stack.last is CollectionDetailViewController {
            stack.removeLast()
        }
        stack.append(detailVC)
        nav.setViewControllers(stack, animated: true)
    }

    func setTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }

    func registerCells() {
        rootView.tableView.register(CreateCollectionHeaderImageCell.self)
        rootView.tableView.register(CreateCollectionTitleInputCell.self)
        rootView.tableView.register(CreateCollectionDescriptionInputCell.self)
        rootView.tableView.register(CreateCollectionVisibilityCell.self)
        rootView.tableView.register(CreateCollectionAddContentHeaderCell.self)
        rootView.tableView.register(CreateCollectionAddContentButtonCell.self)
        rootView.tableView.register(SelectedContentReasonTableViewCell.self)
    }

    func bindViewModel() {
        viewModel.isDoneEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.rootView.setCompleteEnabled(isEnabled)
            }
            .store(in: &cancellables)

        viewModel.createSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] collectionId in
                guard let self, let factory = self.viewControllerFactory else { return }
                let detailVC = factory.makeCollectionDetailViewController(collectionId: collectionId)
                self.replaceCurrentFlowWithDetail(detailVC)
            }
            .store(in: &cancellables)

        viewModel.createFailure
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                let label: String
                switch self?.mode {
                case .edit: label = "UpdateCollection 실패"
                default: label = "CreateCollection 실패"
                }
                print(label + ":", error)
            }
            .store(in: &cancellables)

        rootView.onTapComplete = { [weak self] in
            guard let self else { return }
            self.updateCreatePayload()
            self.viewModel.createCollection()
        }

        rootView.onTapCompleteWhenDisabled = { [weak self] in
            guard let self else { return }
            guard !self.viewModel.isDoneEnabled.value else { return }
            self.showValidationErrors()
        }
    }

    func updateCreatePayload() {
        viewModel.updateTitle(collectionTitleText)
        viewModel.updateDescription(collectionDescriptionText)
        if let visibility = selectedVisibility {
            viewModel.updateVisibility(visibility == .public)
        }
        viewModel.updateImageUrl(headerImageKey ?? "")
        viewModel.updateContentList(makeContentList())

        if selectedReasonItems.count >= 2 {
            if let headerCell = rootView.tableView.cellForRow(
                at: IndexPath(row: 0, section: 1)
            ) as? CreateCollectionAddContentHeaderCell {
                headerCell.setError(false)
            }
        }
    }

    func makeContentList() -> [CreateCollectionEntity.CreateCollectionContents] {
        return selectedReasonItems.map { item in
            return CreateCollectionEntity.CreateCollectionContents(
                contentId: item.contentId,
                isSpoiler: item.isSpoiler,
                reason: item.reasonText ?? "",
                customImages: item.customImageKeys
            )
        }
    }

    func syncReasonItems(with models: [SavedContentItemViewModel]) {
        func key(of model: SavedContentItemViewModel) -> String {
            "\(model.title)|\(model.director)|\(model.year)"
        }

        let existingByKey = Dictionary(uniqueKeysWithValues: selectedReasonItems.map {
            ("\($0.title)|\($0.director)|\($0.year)", $0)
        })

        selectedReasonItems = models.map { model in
            let k = key(of: model)

            if var existing = existingByKey[k] {
                existing.posterURL = model.posterURL
                existing.posterImage = model.posterImage
                return existing
            }

            return SelectedContentReasonTableViewCellItem(
                contentId: model.contentId,
                posterURL: model.posterURL,
                posterImage: model.posterImage,
                title: model.title,
                director: model.director,
                year: model.year,
                isSpoiler: false,
                reasonText: nil
            )
        }

        updateCreatePayload()
    }

    func presentAddContentSelect() {
        guard let factory = viewControllerFactory else { return }

        let vc = factory.makeAddContentSelectViewController()
        vc.initialSelected = selectedContents
        vc.protectedDeleteKeys = Set(
            selectedContents.map { "\($0.title)|\($0.director)|\($0.year)" }
        )

        vc.onComplete = { [weak self] selectedItems in
            guard let self else { return }
            self.selectedContents = selectedItems
            self.syncReasonItems(with: selectedItems)
            self.rootView.tableView.reloadData()
        }

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true)
    }

    func deleteReasonItem(_ item: SelectedContentReasonTableViewCellItem, at index: Int) {
        selectedReasonItems.remove(at: index)

        selectedContents.removeAll { model in
            model.title == item.title &&
            model.director == item.director &&
            model.year == item.year
        }

        updateCreatePayload()
        rootView.tableView.reloadData()
    }

    func presentDeleteConfirmModal(onConfirm: @escaping () -> Void) {
        let hostView: UIView = navigationController?.view ?? view

        var modalRef: Modal?

        let modal = Modal(
            image: DesignSystem.Icon.Gradient.none,
            title: "작품을 삭제할까요?",
            caption: "작성한 내용이 모두 삭제돼요.",
            leftButtonTitle: "취소",
            rightButtonTitle: "삭제",
            rightButtonColor: DesignSystem.Color.error500,
            onLeft: { _ in
                modalRef?.dismiss()
            },
            onRight: { _ in
                modalRef?.dismiss {
                    onConfirm()
                }
            }
        )

        modalRef = modal
        modal.show(in: hostView)
    }

    func showValidationErrors() {
        let isTitleEmpty = collectionTitleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isVisibilityEmpty = selectedVisibility == nil
        let isContentInsufficient = selectedReasonItems.count < 2

        if let titleCell = rootView.tableView.cellForRow(
            at: IndexPath(row: CreateCollectionRow.title.rawValue, section: 0)
        ) as? CreateCollectionTitleInputCell {
            titleCell.setError(isTitleEmpty)
        }

        if let visibilityCell = rootView.tableView.cellForRow(
            at: IndexPath(row: CreateCollectionRow.visibility.rawValue, section: 0)
        ) as? CreateCollectionVisibilityCell {
            visibilityCell.setError(isVisibilityEmpty)
        }

        if let headerCell = rootView.tableView.cellForRow(
            at: IndexPath(row: 0, section: 1)
        ) as? CreateCollectionAddContentHeaderCell {
            headerCell.setError(isContentInsufficient)
        }

        var firstErrorIndexPath: IndexPath?

        if isTitleEmpty {
            firstErrorIndexPath = IndexPath(row: CreateCollectionRow.title.rawValue, section: 0)
        } else if isVisibilityEmpty {
            firstErrorIndexPath = IndexPath(row: CreateCollectionRow.visibility.rawValue, section: 0)
        } else if isContentInsufficient {
            firstErrorIndexPath = IndexPath(row: 0, section: 1)
        }

        var hasEmptyReason = false
        for (index, item) in selectedReasonItems.enumerated() {
            let isEmpty = (item.reasonText ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            if isEmpty {
                hasEmptyReason = true
                if firstErrorIndexPath == nil {
                    firstErrorIndexPath = IndexPath(row: index + 1, section: 1)
                }
            }
            if let cell = rootView.tableView.cellForRow(
                at: IndexPath(row: index + 1, section: 1)
            ) as? SelectedContentReasonTableViewCell {
                cell.setError(isEmpty)
            }
        }

        if isTitleEmpty || isVisibilityEmpty || isContentInsufficient || hasEmptyReason {
            Toast.text("필수 항목을 모두 입력해주세요").show()
        }

        if let indexPath = firstErrorIndexPath {
            rootView.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
