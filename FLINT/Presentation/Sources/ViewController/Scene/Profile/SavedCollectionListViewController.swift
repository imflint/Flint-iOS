//
//  SavedCollectionListViewController.swift
//  FLINT
//
//  Created by 진소은 on 2026/06/19.
//

import UIKit

import View
import ViewModel

import Domain

public protocol SavedCollectionListViewControllerFactory {
    func makeSavedCollectionListViewController() -> SavedCollectionListViewController
}

public final class SavedCollectionListViewController: BaseViewController<CollectionFolderListView> {

    // MARK: - Data

    private let viewModel: SavedCollectionListViewModel

    public init(viewModel: SavedCollectionListViewModel, viewControllerFactory: ViewControllerFactory? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllerFactory = viewControllerFactory
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        applyCount()
        viewModel.load()
    }

    // MARK: - Override

    public override func bind() {
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self

        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.rootView.collectionView.reloadData()
                self.applyCount()
            }
            .store(in: &cancellables)
    }

    public override func setUI() {
        super.setUI()

        view.backgroundColor = DesignSystem.Color.background

        setNavigationBar(
            .init(
                left: .back,
                title: "저장한 컬렉션",
                right: .none,
                backgroundStyle: .solid(DesignSystem.Color.background)
            )
        )
        statusBarBackgroundView.isHidden = true

        navigationBarView.onTapLeft = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Private

    private func applyCount() {
        rootView.countLabel.attributedText = .pretendard(
            .body2_r_14,
            text: "총 \(viewModel.items.count)개",
            color: DesignSystem.Color.gray100
        )
    }
}

// MARK: - UICollectionViewDataSource

extension SavedCollectionListViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionFolderCollectionViewCell.self),
            for: indexPath
        ) as? CollectionFolderCollectionViewCell else {
            return UICollectionViewCell()
        }

        let entity = viewModel.items[indexPath.item]

        let firstURL = entity.imageList.first ?? entity.thumbnailUrl
        let secondURL = entity.imageList[safe: 1]
        let profileURL = entity.user.profileImageUrl

        cell.configure(
            .init(
                firstPosterURL: firstURL,
                secondPosterURL: secondURL,
                profileImageURL: profileURL,
                name: entity.user.nickname,
                title: entity.title,
                description: entity.description,
                isBookmarked: entity.isBookmarked,
                bookmarkedCountText: "\(entity.bookmarkCount)"
            )
        )

        cell.onTapBookmark = { [weak self, weak cell] isBookmarked, _ in
            guard let self, let cell,
                  let indexPath = collectionView.indexPath(for: cell) else { return }

            let wasBookmarked = self.viewModel.items[indexPath.item].isBookmarked

            self.viewModel.updateBookmark(at: indexPath.item, isBookmarked: isBookmarked)

            if wasBookmarked == false, isBookmarked == true {
                Toast.action(
                    image: DesignSystem.Icon.Gradient.bookmark,
                    title: "취향이 하나 더 쌓였어요",
                    actionTitle: "저장한 컬렉션 보러가기",
                    action: { _ in
                        print("컬렉션 저장")
                    }
                ).show()
                return
            }

            if wasBookmarked == true, isBookmarked == false {
                Toast.text("컬렉션 저장이 취소되었어요").show()
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SavedCollectionListViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(at: indexPath)
    }

    private func didSelectItem(at indexPath: IndexPath) {
        let entity = viewModel.items[indexPath.item]

        guard let collectionId = Int64(entity.id) else {
            print("invalid collectionId:", entity.id)
            return
        }

        guard let factory = viewControllerFactory else { return }
        let vc = factory.makeCollectionDetailViewController(collectionId: collectionId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SavedCollectionListViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sideInset: CGFloat = 24
        let interItem: CGFloat = 19

        let availableWidth = collectionView.bounds.width - (sideInset * 2) - interItem
        let cellWidth = floor(availableWidth / 2)

        let textHeight: CGFloat = 93
        let cellHeight = cellWidth + textHeight

        return CGSize(width: cellWidth, height: cellHeight)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 18, left: 24, bottom: 24, right: 24)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { 19 }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { 24 }
}
