//
//  AddContentSelectViewController.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

import View

public final class AddContentSelectViewController: BaseViewController<AddContentSelectView> {
    
    //MARK: - Output
    public var onComplete: (([SavedContentItemViewModel]) -> Void)?
    
    //MARK: - Input
    public var initialSelected: [SavedContentItemViewModel] = []
    public var protectedDeleteKeys: Set<String> = []
    
    // MARK: - Property
    
    private var results: [SavedContentItemViewModel] = []
    private var selected: [SavedContentItemViewModel] = []
    
    private var isSearching: Bool = false
    
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
        
        selected = initialSelected
        
        isSearching = false
        results = makePopularResults()
        
        applyUI()
        updateAddButtonState()
    }
    
    public override func setUI() {
        super.setUI()
        view.backgroundColor = DesignSystem.Color.background
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
    
    private func applyUI() {
        rootView.setPreviewHidden(selected.isEmpty)

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
        let isActive = selected.count >= 2
        let color: UIColor = isActive ? DesignSystem.Color.secondary400 : DesignSystem.Color.gray300
        
        navigationBarView.applyRight(.text(title: "추가", color: color))
        
        navigationBarView.onTapRight = { [weak self] in
            guard let self else { return }
            guard isActive else { return }
            self.onComplete?(self.selected)
            self.dismiss(animated: true)
        }
    }
    
    private func key(of model: SavedContentItemViewModel) -> String {
        "\(model.title)|\(model.director)|\(model.year)"
    }
    
    private func makePopularResults() -> [SavedContentItemViewModel] {
        [
            .init(posterImage: nil, title: "듄: 파트 2", director: "드니 빌뇌브", year: "2024"),
            .init(posterImage: nil, title: "오펜하이머", director: "크리스토퍼 놀란", year: "2023"),
            .init(posterImage: nil, title: "스즈메의 문단속", director: "신카이 마코토", year: "2022"),
            .init(posterImage: nil, title: "어바웃 타임", director: "리처드 커티스", year: "2013"),
            .init(posterImage: nil, title: "헤어질 결심", director: "박찬욱", year: "2022")
        ]
    }
    
    @objc private func didChangeSearchText() {
        let text = rootView.searchTextField.text ?? ""
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            isSearching = false
            results = makePopularResults()
            applyUI()
            return
        }

        isSearching = true

        // TODO: 검색 API 연결 시 여기서 호출
        results = [
            SavedContentItemViewModel(posterImage: nil, title: "\(trimmed)를 여행하는 히치하이커를 위한 안내서", director: "가스 제닝스", year: "2005"),
            SavedContentItemViewModel(posterImage: nil, title: "\(trimmed)를 달리는 밤", director: "스기이 기사부로", year: "1985"),
        ]

        applyUI()
    }

    
    @objc private func didTapRemovePreview(_ sender: UIButton) {
        let index = sender.tag
        guard selected.indices.contains(index) else { return }
        
        let model = selected[index]
        
        if protectedDeleteKeys.contains(key(of: model)) {
            showDeleteConfirmModal { [weak self] confirmed in
                guard let self else { return }
                guard confirmed else { return }
                self.selected.remove(at: index)
                self.applyUI()
            }
            return
        }
        
        selected.remove(at: index)
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
        
        let model = results[indexPath.section]
        
        //TODO: - 검색어 PATCH
        let isSame: (SavedContentItemViewModel) -> Bool = { item in
            item.title == model.title &&
            item.director == model.director &&
            item.year == model.year
        }
        
        let isSelected = selected.contains(where: isSame)
        cell.configure(model: model, isSelected: isSelected)
        
        cell.onTapCheckbox = { [weak self, weak cell] isChecked in
            guard let self else { return }
            
            if isChecked {
                guard self.selected.count < 10 else {
                    cell?.configure(model: model, isSelected: false)
                    return
                }
                if !self.selected.contains(where: isSame) {
                    self.selected.append(model)
                }
            } else {
                self.selected.removeAll(where: isSame)
            }
            self.applyUI()
        }
        return cell
    }
}


// MARK: - UITableViewDelegate

extension AddContentSelectViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = results[indexPath.section]
        
        let isSame: (SavedContentItemViewModel) -> Bool = {
            $0.title == item.title && $0.director == item.director && $0.year == item.year
        }
        
        if let idx = selected.firstIndex(where: isSame) {
            selected.remove(at: idx)
        } else {
            guard selected.count < 10 else { return }
            selected.append(item)
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
        selected.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilmPreviewCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! FilmPreviewCollectionViewCell
        
        // TODO: 썸네일이 여기서 이미지 세팅
        
        cell.xButton.tag = indexPath.item
        cell.xButton.addTarget(self, action: #selector(didTapRemovePreview(_:)), for: .touchUpInside)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AddContentSelectViewController: UICollectionViewDelegate { }
