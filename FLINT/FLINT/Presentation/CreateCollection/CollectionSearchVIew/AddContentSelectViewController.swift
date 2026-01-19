//
//  AddContentSelectViewController.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit

final class AddContentSelectViewController: BaseViewController<AddContentSelectView> {
    
    //MARK: - Output
    
    var onComplete: (([SavedContentItemViewModel]) -> Void)?
    
    //MARK: - Input
    var initialSelected: [SavedContentItemViewModel] = []
    var protectedDeleteKeys: Set<String> = []
    
    // MARK: - Property
    
    private var results: [SavedContentItemViewModel] = []
    private var selected: [SavedContentItemViewModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(
            .init(
                left: .back,
                title: "작품 추가하기",
                right: .text(title: "추가", color: .flintGray300),
                backgroundStyle: .solid(.flintBackground)
            )
        )
        configureViews()
        
        selected = initialSelected
        applyUI()
        updateAddButtonState()
    }
    
    override func setUI() {
        super.setUI()
        view.backgroundColor = .flintBackground
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
        rootView.setEmptyHidden(hasResult)
        
        rootView.selectedPreviewCollectionView.reloadData()
        rootView.tableView.reloadData()
        updateAddButtonState()
    }
    
    private func updateAddButtonState() {
        let isActive = selected.count >= 2
        let color: UIColor = isActive ? .flintSecondary400 : .flintGray300
        
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
    
    @objc private func didChangeSearchText() {
        let text = rootView.searchTextField.text ?? ""
        
        if text.isEmpty {
            results = []
        } else {
            results = [
                SavedContentItemViewModel(posterImage: nil, title: "\(text)를 여행하는 히치하이커를 위한 안내서", director: "가스 제닝스", year: "2005"),
                SavedContentItemViewModel(posterImage: nil, title: "\(text)를 달리는 밤", director: "스기이 기사부로", year: "1985"),
                SavedContentItemViewModel(posterImage: nil, title: "\(text)", director: "김수용", year: "1967"),
                SavedContentItemViewModel(posterImage: nil, title: "\(text)", director: "ㅇㅇㅇ", year: "167"),
                SavedContentItemViewModel(posterImage: nil, title: "\(text)", director: "김용", year: "967"),
                SavedContentItemViewModel(posterImage: nil, title: "\(text)", director: "김", year: "167"),
                SavedContentItemViewModel(posterImage: nil, title: "\(text)", director: "용", year: "17"),
            ]
        }
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
            image: .icNoneGradient,
            title: "작품을 삭제할까요?",
            caption: "작성한 내용이 모두 삭제돼요.",
            leftButtonTitle: "취소",
            rightButtonTitle: "삭제",
            rightButtonColor: .flintError500,
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == results.count - 1 ? 0 : 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}


// MARK: - UICollectionViewDataSource

extension AddContentSelectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
