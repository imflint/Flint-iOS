//
//  SavedFilmListViewController.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import UIKit

import View
import ViewModel

import Domain

public protocol SavedFilmListViewControllerFactory {
    func makeSavedFilmListViewController() -> SavedFilmListViewController
}

public final class SavedFilmListViewController: BaseViewController<SavedFilmListView> {

    private let viewModel: SavedFilmListViewModel

    public init(viewModel: SavedFilmListViewModel, viewControllerFactory: ViewControllerFactory? = nil) {
        self.viewModel = viewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearch()
        bind()
        viewModel.load()
    }

    public override func setUI() {
        super.setUI()

        view.backgroundColor = DesignSystem.Color.background

        setNavigationBar(
            .init(
                left: .back,
                title: "저장 작품",
                right: .none,
                backgroundStyle: .solid(DesignSystem.Color.background)
            )
        )
        statusBarBackgroundView.isHidden = true

        navigationBarView.onTapLeft = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    public override func bind() {
        viewModel.$displayItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$totalCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.rootView.countLabel.attributedText = .pretendard(
                    .body2_r_14,
                    text: "총 \(count)개",
                    color: DesignSystem.Color.gray100
                )
            }
            .store(in: &cancellables)

        viewModel.bookmarkRemovalBlocked
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentMinimumBookmarkModal()
            }
            .store(in: &cancellables)
    }

    // MARK: - Setup

    private func setupTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.register(SavedFilmListRowCell.self)
        rootView.tableView.rowHeight = UITableView.automaticDimension
        rootView.tableView.estimatedRowHeight = 152
    }

    private func setupSearch() {
        rootView.searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )
    }

    @objc private func searchTextChanged() {
        viewModel.updateQuery(rootView.searchTextField.text ?? "")
    }

    // MARK: - Action

    private func presentOTTBottomSheet(platforms: [OTTPlatform]) {
        let vc = BaseBottomSheetViewController(content: .ott(platforms: platforms))
        present(vc, animated: false)
    }

    private func presentMinimumBookmarkModal() {
        let host: UIView = navigationController?.view ?? view
        Modal.presentMinimumBookmarkLimit(in: host)
    }
}

// MARK: - UITableViewDataSource

extension SavedFilmListViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.displayItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SavedFilmListRowCell.self, for: indexPath)
        let item = viewModel.displayItems[indexPath.row]
        cell.configure(with: item)
        cell.onTapOTT = { [weak self] in
            guard let self else { return }
            let platforms: [OTTPlatform] = item.ottList.compactMap { ott in
                OTTPlatform.fromServerName(ott.ottName)
            }
            guard !platforms.isEmpty else { return }
            self.presentOTTBottomSheet(platforms: platforms)
        }
        cell.onTapBookmark = { [weak self] isBookmarked in
            guard let self, !isBookmarked else { return }

            // 최소 개수 미달이면 가드가 발동해서 리스트가 변하지 않음.
            // 결과와 무관하게 시각 상태를 복원하기 위해 항상 reload.
            let beforeCount = self.viewModel.displayItems.count
            self.viewModel.toggleBookmark(contentIdString: item.id)
            let afterCount = self.viewModel.displayItems.count

            if afterCount == beforeCount {
                // 변화 없음 → 차단됨. 셀의 북마크 시각을 원복
                if let indexPath = tableView.indexPath(for: cell) {
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            } else {
                Toast.text("작품 저장을 취소했어요").show()
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SavedFilmListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 하단 근처(마지막 3행 이내) 진입 시 다음 페이지 로드
        if indexPath.row >= viewModel.displayItems.count - 3 {
            viewModel.loadNextPage()
        }
    }
}
