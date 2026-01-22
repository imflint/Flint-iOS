//
//  AddContentSelectViewController.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

import Domain

import View
import ViewModel

public final class AddContentSelectViewController: BaseViewController<AddContentSelectView> {

    // MARK: - Output

    public var onComplete: (([SavedContentItemViewModel]) -> Void)?

    // MARK: - Input

    public var initialSelected: [SavedContentItemViewModel] = []
    public var protectedDeleteKeys: Set<String> = []

    // MARK: - Dependency

    private let viewModel: AddContentSelectViewModel

    // MARK: - Property

    private var results: [SearchContentsEntity.SearchContent] = []
    private var selectedEntities: [SearchContentsEntity.SearchContent] = []

    private var selectedViewModels: [SavedContentItemViewModel] = []

    private var isSearching: Bool = false

    // MARK: - Init

    public init(viewModel: AddContentSelectViewModel, viewControllerFactory: ViewControllerFactory? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(
            .init(
                left: .back,
                title: "작품 추가하기",
                right: .text(title: "추가", color: DesignSystem.Color.gray300),
                backgroundStyle: .solid(DesignSystem.Color.background)
            )
        )

        configureViews()

        selectedViewModels = initialSelected
        selectedEntities = []
        isSearching = false
        results = makePopularResults()

        applyUI()
    }

    public override func setUI() {
        super.setUI()
        view.backgroundColor = DesignSystem.Color.background
    }

    // MARK: - Bind (BaseViewController Override)

    public override func bind() {
        super.bind()

        viewModel.isSearching
            .receive(on: RunLoop.main)
            .sink { [weak self] searching in
                guard let self else { return }
                self.isSearching = searching

                if !searching {
                    self.results = self.makePopularResults()
                }
                self.applyUI()
            }
            .store(in: &cancellables)

        viewModel.results
            .receive(on: RunLoop.main)
            .sink { [weak self] newResults in
                guard let self else { return }

                guard self.isSearching else { return }

                self.results = newResults
                self.syncSelectedEntitiesFromResultsIfNeeded()
                self.applyUI()
            }
            .store(in: &cancellables)

    }

    // MARK: - Setup

    private func configureViews() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.register(SelectableContentTableViewCell.self)

        rootView.selectedPreviewCollectionView.dataSource = self
        rootView.selectedPreviewCollectionView.delegate = self

        rootView.searchTextField.addTarget(self, action: #selector(didChangeSearchText), for: .editingChanged)
    }

    // MARK: - UI

    private func applyUI() {
        rootView.setPreviewHidden(selectedViewModels.isEmpty)

        let hasResult = !results.isEmpty

        if isSearching {
            rootView.setEmptyHidden(hasResult)
        } else {
            rootView.setEmptyHidden(true)
        }

        rootView.selectedPreviewCollectionView.reloadData()
        rootView.tableView.reloadData()
        updateAddButtonState()
    }

    private func updateAddButtonState() {
        let isActive = selectedViewModels.count >= 1
        let color: UIColor = isActive ? DesignSystem.Color.secondary400 : DesignSystem.Color.gray300

        navigationBarView.applyRight(.text(title: "추가", color: color))

        navigationBarView.onTapRight = { [weak self] in
            guard let self else { return }
            guard self.selectedViewModels.count >= 1 else { return }
            self.onComplete?(self.selectedViewModels)
            self.dismiss(animated: true)
        }
    }

    // MARK: - Helpers

    private func key(of vm: SavedContentItemViewModel) -> String {
        "\(vm.title)|\(vm.director)|\(vm.year)"
    }

    private func key(of entity: SearchContentsEntity.SearchContent) -> String {
        "\(entity.title)|\(entity.author)|\(entity.year)"
    }

    private func makePopularResults() -> [SearchContentsEntity.SearchContent] {
        [
            .init(id: "popular-1", title: "듄: 파트 2", author: "드니 빌뇌브", posterUrl: nil, year: 2024),
            .init(id: "popular-2", title: "오펜하이머", author: "크리스토퍼 놀란", posterUrl: nil, year: 2023),
            .init(id: "popular-3", title: "스즈메의 문단속", author: "신카이 마코토", posterUrl: nil, year: 2022),
            .init(id: "popular-4", title: "어바웃 타임", author: "리처드 커티스", posterUrl: nil, year: 2013),
            .init(id: "popular-5", title: "헤어질 결심", author: "박찬욱", posterUrl: nil, year: 2022)
        ]
    }

    private func toViewModel(_ entity: SearchContentsEntity.SearchContent) -> SavedContentItemViewModel {
        SavedContentItemViewModel(
            posterURL: entity.posterUrl,
            posterImage: nil,
            title: entity.title,
            director: entity.author,
            year: String(entity.year)
        )
    }

    private func syncSelectedEntitiesFromResultsIfNeeded() {
        guard !results.isEmpty else { return }
        let selectedKeys = Set(selectedViewModels.map(key(of:)))
        let matched = results.filter { selectedKeys.contains(key(of: $0)) }

        if selectedEntities.isEmpty && !matched.isEmpty {
            selectedEntities = matched
        }
    }

    // MARK: - Actions

    @objc private func didChangeSearchText() {
        let text = rootView.searchTextField.text ?? ""
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            isSearching = true
            viewModel.updateKeyword(keyword: "")
            applyUI()
            return
        }


        isSearching = true
        viewModel.updateKeyword(keyword: trimmed)
        applyUI()
    }

    @objc private func didTapRemovePreview(_ sender: UIButton) {
        let index = sender.tag
        guard selectedViewModels.indices.contains(index) else { return }

        let vm = selectedViewModels[index]

        if protectedDeleteKeys.contains(key(of: vm)) {
            showDeleteConfirmModal { [weak self] confirmed in
                guard let self else { return }
                guard confirmed else { return }
                self.removeSelected(at: index)
            }
            return
        }

        removeSelected(at: index)
    }

    private func removeSelected(at index: Int) {
        let removed = selectedViewModels.remove(at: index)

        let k = key(of: removed)
        selectedEntities.removeAll { key(of: $0) == k }

        applyUI()
    }

    private func showDeleteConfirmModal(onResult: @escaping (Bool) -> Void) {
        var modal: Modal?

        modal = Modal(
            image: DesignSystem.Icon.Gradient.none,
            title: "작품을 삭제할까요?",
            caption: "작성한 내용이 모두 삭제돼요.",
            leftButtonTitle: "취소",
            rightButtonTitle: "삭제",
            rightButtonColor: DesignSystem.Color.error500,
            onLeft: { _ in
                modal?.dismiss {
                    onResult(false)
                    modal = nil
                }
            },
            onRight: { _ in
                modal?.dismiss {
                    onResult(true)
                    modal = nil
                }
            }
        )

        guard let modal else { return }
        modal.show(in: view)
    }
}

// MARK: - UITableViewDataSource

extension AddContentSelectViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        results.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectableContentTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! SelectableContentTableViewCell

        let entity = results[indexPath.section]
        let isSelected = selectedViewModels.contains(where: { key(of: $0) == key(of: entity) })

        let vm = toViewModel(entity)

        cell.configure(model: vm, isSelected: isSelected)

        if let url = entity.posterUrl {
            cell.posterImageView.kf.setImage(with: url)
        } else {
            cell.posterImageView.image = nil
        }

        cell.onTapCheckbox = { [weak self] isChecked in
            guard let self else { return }

            let vm = self.toViewModel(entity)

            if isChecked {
                guard self.selectedViewModels.count < 10 else { return }
                if !self.selectedViewModels.contains(where: { self.key(of: $0) == self.key(of: entity) }) {
                    self.selectedViewModels.append(vm)
                    self.selectedEntities.append(entity)
                }
            } else {
                let k = self.key(of: entity)
                self.selectedViewModels.removeAll { self.key(of: $0) == k }
                self.selectedEntities.removeAll { self.key(of: $0) == k }
            }

            self.applyUI()
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddContentSelectViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = results[indexPath.section]
        let k = key(of: entity)

        if let idx = selectedViewModels.firstIndex(where: { key(of: $0) == k }) {
            selectedViewModels.remove(at: idx)
            selectedEntities.removeAll { key(of: $0) == k }
        } else {
            guard selectedViewModels.count < 10 else { return }
            selectedViewModels.append(toViewModel(entity))
            selectedEntities.append(entity)
        }

        applyUI()
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == results.count - 1 ? 0 : 12
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

// MARK: - UICollectionViewDataSource

extension AddContentSelectViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedViewModels.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilmPreviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! FilmPreviewCollectionViewCell

        let vm = selectedViewModels[indexPath.item]

        if let url = vm.posterURL {
            cell.imageView.kf.setImage(with: url)
        } else {
            cell.imageView.image = vm.posterImage
        }

        cell.xButton.tag = indexPath.item
        cell.xButton.addTarget(self, action: #selector(didTapRemovePreview(_:)), for: .touchUpInside)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AddContentSelectViewController: UICollectionViewDelegate { }
