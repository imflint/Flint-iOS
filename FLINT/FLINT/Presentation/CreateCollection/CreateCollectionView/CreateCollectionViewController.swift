//
//  CreateCollectionViewController.swift
//  FLINT
//
//  Created by 소은 on 1/19/26.
//

import UIKit
import Combine

final class CreateCollectionViewController: BaseViewController<CreateCollectionView> {
    
    enum CreateCollectionRow: Int, CaseIterable {
        case header
        case title
        case description
        case visibility
        case addContent
    }
    
    private let viewModel: CreateCollectionViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let titleChangeSubject = PassthroughSubject<String, Never>()
    
    private var selectedContents: [SavedContentItemViewModel] = []
    private var selectedReasonItems: [SelectedContentReasonTableViewCellItem] = []
    
    private let visibilitySubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedCountSubject = CurrentValueSubject<Int, Never>(0)
    
    // MARK: - init
    
    init(viewModel: CreateCollectionViewModel = CreateCollectionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bindViewModel()
        
    }
    
    // MARK: - Setup
    
    override func setUI() {
        super.setUI()
        view.backgroundColor = .flintBackground
        
        setNavigationBar(
            .init(
                left: .back,
                right: .none,
                backgroundStyle: .solid(.flintBackground)
            )
        )
    }
}

//MARK: - Private

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
                // TODO: 완료 버튼 만들면 여기서 enable/disable 처리
                guard self != nil else { return }
                _ = isEnabled
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
    }
}

// MARK: - UITableViewDataSource

extension CreateCollectionViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return CreateCollectionRow.allCases.count
        } else {
            return selectedReasonItems.count
        }
    }

    func tableView(
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

                cell.onChangeTitle = { [weak titleChangeSubject] text in
                    titleChangeSubject?.send(text)
                }
                return cell

            case .description:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionDescriptionInputCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionDescriptionInputCell

                cell.onChangeDescription = { _ in
                    // TODO: descriptionSubject 연결 예정
                }
                return cell

            case .visibility:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionVisibilityCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionVisibilityCell

                cell.onChangeVisibility = { [weak visibilitySubject] _ in
                    visibilitySubject?.send(true)
                }
                return cell

            case .addContent:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CreateCollectionAddContentCell.reuseIdentifier,
                    for: indexPath
                ) as! CreateCollectionAddContentCell

                cell.onTapAdd = { [weak self] in
                    guard let self else { return }
                    
                    let vc = AddContentSelectViewController()
                    vc.onComplete = { [weak self] selectedItems in
                        guard let self else { return }
                        
                        self.selectedContents = selectedItems
                        self.syncReasonItems(with: selectedItems)
                        self.selectedCountSubject.send(self.selectedReasonItems.count)
                        self.rootView.tableView.reloadData()
                    }


                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }

                return cell
            }
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectedContentReasonTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! SelectedContentReasonTableViewCell

        let item = selectedReasonItems[indexPath.row]
        cell.configure(with: item)

        cell.onTapClose = { [weak self] in
            guard let self else { return }

            self.selectedReasonItems.remove(at: indexPath.row)
            self.selectedContents.removeAll { model in
                model.title == item.title &&
                model.director == item.director &&
                model.year == item.year
            }
            self.selectedCountSubject.send(self.selectedReasonItems.count)
            self.rootView.tableView.reloadData()
        }

        cell.onToggleSpoiler = { [weak self] isOn in
            guard let self else { return }
            self.selectedReasonItems[indexPath.row].isSpoiler = isOn
        }

        cell.onChangeReasonText = { [weak self] text in
            guard let self else { return }
            self.selectedReasonItems[indexPath.row].reasonText = text
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateCollectionViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 0 { return 220 }
        return UITableView.automaticDimension
    }
}
