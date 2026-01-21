//
//  CreateCollectionViewController.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit
import Combine

import View
import ViewModel

public final class CreateCollectionViewController: BaseViewController<CreateCollectionView> {

    // MARK: - Enum

    enum CreateCollectionRow: Int, CaseIterable {
        case header
        case title
        case description
        case visibility
        case addContent
    }

    // MARK: - State

    private var collectionTitleText: String = ""
    private var collectionDescriptionText: String = ""

    private var selectedContents: [SavedContentItemViewModel] = []
    private var selectedReasonItems: [SelectedContentReasonTableViewCellItem] = []

    private let viewModel: CreateCollectionViewModel

    private var cancellables = Set<AnyCancellable>()
    private let titleChangeSubject = PassthroughSubject<String, Never>()
    private let visibilitySubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedCountSubject = CurrentValueSubject<Int, Never>(0)

    // MARK: - Init

    public init(viewModel: CreateCollectionViewModel = CreateCollectionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bindViewModel()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.refreshFooterLayout()
    }

    // MARK: - Setup

    public override func setUI() {
        super.setUI()

        view.backgroundColor = DesignSystem.Color.background

        setNavigationBar(
            .init(
                left: .back,
                right: .none,
                backgroundStyle: .solid(DesignSystem.Color.background)
            )
        )
    }
}

// MARK: - Private

private extension CreateCollectionViewController {

    func setTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }

    func registerCells() {
        rootView.tableView.register(CreateCollectionHeaderImageCell.self)
        rootView.tableView.register(CreateCollectionTitleInputCell.self)
        rootView.tableView.register(CreateCollectionDescriptionInputCell.self)
        rootView.tableView.register(CreateCollectionVisibilityCell.self)
        rootView.tableView.register(CreateCollectionAddContentCell.self)
        rootView.tableView.register(SelectedContentReasonTableViewCell.self)
    }

    func bindViewModel() {
        let input = CreateCollectionViewModel.Input(
            titleChange: titleChangeSubject.eraseToAnyPublisher(),
            visibilitySelected: visibilitySubject.eraseToAnyPublisher(),
            selectedCount: selectedCountSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.isDoneEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.rootView.setCompleteEnabled(isEnabled)
            }
            .store(in: &cancellables)
    }

    func syncReasonItems(with models: [SavedContentItemViewModel]) {
        func key(of model: SavedContentItemViewModel) -> String {
            "\(model.title)|\(model.director)|\(model.year)"
        }

        let existingByKey = Dictionary(uniqueKeysWithValues: selectedReasonItems.map {
            (key(of: .init(posterImage: $0.posterImage, title: $0.title, director: $0.director, year: $0.year)), $0)
        })

        selectedReasonItems = models.map { model in
            let k = key(of: model)
            if let existing = existingByKey[k] {
                return existing
            }
            return SelectedContentReasonTableViewCellItem(
                posterImage: model.posterImage,
                title: model.title,
                director: model.director,
                year: model.year,
                isSpoiler: false,
                reasonText: nil
            )
        }

        selectedCountSubject.send(selectedReasonItems.count)
    }

    func presentAddContentSelect() {
        let vc = AddContentSelectViewController()
        vc.initialSelected = selectedContents
        vc.protectedDeleteKeys = Set(selectedContents.map { "\($0.title)|\($0.director)|\($0.year)" })

        vc.onComplete = { [weak self] selectedItems in
            guard let self else { return }
            self.selectedContents = selectedItems
            self.syncReasonItems(with: selectedItems)
            self.rootView.tableView.reloadData()
        }

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    func deleteReasonItem(_ item: SelectedContentReasonTableViewCellItem, at index: Int) {
        selectedReasonItems.remove(at: index)

        selectedContents.removeAll { model in
            model.title == item.title &&
            model.director == item.director &&
            model.year == item.year
        }

        selectedCountSubject.send(selectedReasonItems.count)
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
}

// MARK: - UITableViewDataSource

extension CreateCollectionViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return CreateCollectionRow.allCases.count - 1
        } else {
            return selectedReasonItems.count + 1
        }
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let row = CreateCollectionRow(rawValue: indexPath.row) else { return UITableViewCell() }

            switch row {
            case .header:
                return tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionHeaderImageCell.reuseIdentifier,
                    for: indexPath
                )

            case .title:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionTitleInputCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionTitleInputCell

                cell.onChangeTitle = { [weak self] text in
                    self?.collectionTitleText = text
                    self?.titleChangeSubject.send(text)
                }
                cell.setText(collectionTitleText)
                return cell

            case .description:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionDescriptionInputCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionDescriptionInputCell

                cell.onChangeDescription = { [weak self] text in
                    self?.collectionDescriptionText = text
                }
                cell.setText(collectionDescriptionText)
                return cell

            case .visibility:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionVisibilityCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionVisibilityCell

                cell.onChangeVisibility = { [weak self] visibility in
                    let isPublic = (visibility == .public)
                    self?.visibilitySubject.send(isPublic)
                }
                return cell

            case .addContent:
                return UITableViewCell()
            }
        }

        if indexPath.row < selectedReasonItems.count {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SelectedContentReasonTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! SelectedContentReasonTableViewCell

            let item = selectedReasonItems[indexPath.row]
            cell.configure(with: item)

            cell.onTapClose = { [weak self, weak cell] in
                guard let self, let cell,
                      let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }

                let item = self.selectedReasonItems[indexPath.row]
                self.deleteReasonItem(item, at: indexPath.row)
            }

            cell.onTapCloseWithDraft = { [weak self, weak cell] in
                guard let self, let cell,
                      let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }

                let item = self.selectedReasonItems[indexPath.row]
                self.presentDeleteConfirmModal {
                    self.deleteReasonItem(item, at: indexPath.row)
                }
            }

            cell.onToggleSpoiler = { [weak self, weak cell] isOn in
                guard let self, let cell,
                      let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                self.selectedReasonItems[indexPath.row].isSpoiler = isOn
            }

            cell.onChangeReasonText = { [weak self, weak cell] text in
                guard let self, let cell,
                      let indexPath = self.rootView.tableView.indexPath(for: cell) else { return }
                self.selectedReasonItems[indexPath.row].reasonText = text
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateCollectionAddContentCell.reuseIdentifier,
                for: indexPath
            ) as! CreateCollectionAddContentCell

            cell.onTapAdd = { [weak self] in
                self?.presentAddContentSelect()
            }

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension CreateCollectionViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 0 { return 220 }
        return UITableView.automaticDimension
    }
}
