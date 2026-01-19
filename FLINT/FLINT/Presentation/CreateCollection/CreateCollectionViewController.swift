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
        rootView.tableView.register(
            CreateCollectionHeaderImageCell.self,
            forCellReuseIdentifier: CreateCollectionHeaderImageCell.reuseIdentifier
        )
        
        rootView.tableView.register(
            CreateCollectionTitleInputCell.self,
            forCellReuseIdentifier: CreateCollectionTitleInputCell.reuseIdentifier
        )
        
        rootView.tableView.register(
            CreateCollectionDescriptionInputCell.self,
            forCellReuseIdentifier: CreateCollectionDescriptionInputCell.reuseIdentifier
        )
        
        rootView.tableView.register(
            CreateCollectionVisibilityCell.self,
            forCellReuseIdentifier:
                CreateCollectionVisibilityCell.reuseIdentifier
        )
        rootView.tableView.register(
            CreateCollectionAddContentCell.self,
            forCellReuseIdentifier: CreateCollectionAddContentCell.reuseIdentifier
        )
    }
    
    func bindViewModel() {
        let input = CreateCollectionViewModel.Input(
            titleChange: titleChangeSubject.eraseToAnyPublisher()
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
}

extension CreateCollectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CreateCollectionRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            
            cell.onChangeDescription = { text in
                // TODO: descriptionSubject 연결 예정
                _ = text
            }
            return cell
            
        case .visibility:
            print("visibility cell")
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateCollectionVisibilityCell.reuseIdentifier,
                for: indexPath
            ) as! CreateCollectionVisibilityCell
            
            cell.onChangeVisibility = { visibility in
                // TODO: visibilitySubject 연결 예정
                _ = visibility
            }
            return cell
            
            
        case .addContent:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateCollectionAddContentCell.reuseIdentifier,
                for: indexPath
            ) as! CreateCollectionAddContentCell
            
            cell.onTapAdd = {
                print("작품 추가하기 탭") // TODO: 작품 선택 화면 push/present
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension CreateCollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 220 }
        return UITableView.automaticDimension
    }
}
