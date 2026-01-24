//
//  CollectionFolderListViewController.swift
//  FLINT
//
//  Created by 소은 on 1/20/26.
//

import UIKit

import View
import ViewModel

import Domain

public final class CollectionFolderListViewController: BaseViewController<CollectionFolderListView> {
    
    // MARK: - Data
    
  //  private var items: [FolderItem] = FolderItem.mock()
    private let viewModel: CollectionFolderListViewModel
    
    public init(viewModel: CollectionFolderListViewModel, viewControllerFactory: ViewControllerFactory? = nil) {
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
                title: "눈여겨보고 있는 컬렉션",
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

extension CollectionFolderListViewController: UICollectionViewDataSource {
    
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

        let firstURL = URL(string: entity.imageList.first ?? entity.thumbnailUrl)
        let secondString = entity.imageList.count > 1 ? entity.imageList[1] : nil
        let secondURL = secondString.flatMap(URL.init(string:))
        let profileURL = URL(string: entity.profileImageUrl)

        cell.configure(
            .init(
                firstPosterURL: firstURL,
                secondPosterURL: secondURL,
                profileImageURL: profileURL,
                name: entity.nickname,
                title: entity.title,
                description: entity.description,
                isBookmarked: entity.isBookmarked,
                bookmarkedCountText: "\(entity.bookmarkCount)"
            )
        )
        
        cell.onTapCard = { [weak self, weak collectionView, weak cell] in
            guard
                let self,
                let collectionView,
                let cell,
                let currentIndexPath = collectionView.indexPath(for: cell)
            else { return }
            self.didSelectItem(at: currentIndexPath)
        }
        
        cell.onTapBookmark = { [weak self, weak cell] isBookmarked, count in
            guard let self, let cell,
                  let indexPath = collectionView.indexPath(for: cell) else { return }

            let wasBookmarked = self.viewModel.items[indexPath.item].isBookmarked

            self.viewModel.updateBookmark(at: indexPath.item, isBookmarked: isBookmarked)

            if wasBookmarked == false, isBookmarked == true {
                Toast.action(
                    image: DesignSystem.Icon.Gradient.bookmark,
                    title: "컬렉션을 저장했어요",
                    actionTitle: "컬렉션 보기",
                    action: { _ in
                      //TODO: - 저장된 컬렉션 뷰로 이동
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

extension CollectionFolderListViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(at: indexPath)
    }
    
    private func didSelectItem(at indexPath: IndexPath) {
        // TODO: 컬렉션 상세화면 이동
    }
}

extension CollectionFolderListViewController: UICollectionViewDelegateFlowLayout {

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

// MARK: - FolderItem (화면 전용 더미 모델)

private extension CollectionFolderListViewController {
    
    struct FolderItem {
        let firstPosterImage: UIImage?
        let secondPosterImage: UIImage?
        
        let profileImage: UIImage?
        let name: String
        
        let title: String
        let description: String
        
        var isBookmarked: Bool
        let bookmarkedCountText: String?
        
        static func mock() -> [FolderItem] {
            return [
                .init(
                    firstPosterImage: nil,
                    secondPosterImage: nil,
                    profileImage: DesignSystem.Image.Common.profileBlue,
                    name: "닉네임",
                    title: "한번 보면 못 빠져나오는 사랑이야기",
                    description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                    isBookmarked: true,
                    bookmarkedCountText: "123"
                ),
                .init(
                    firstPosterImage: nil,
                    secondPosterImage: nil,
                    profileImage: DesignSystem.Image.Common.profileBlue,
                    name: "닉네임",
                    title: "한번 보면 못 빠져나오는 사랑이야기",
                    description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                    isBookmarked: true,
                    bookmarkedCountText: "123"
                ),
                .init(
                    firstPosterImage: nil,
                    secondPosterImage: nil,
                    profileImage: DesignSystem.Image.Common.profileBlue,
                    name: "닉네임",
                    title: "한번 보면 못 빠져나오는 사랑이야기",
                    description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                    isBookmarked: false,
                    bookmarkedCountText: "123"
                ),
                .init(
                    firstPosterImage: nil,
                    secondPosterImage: nil,
                    profileImage: nil,
                    name: "닉네임",
                    title: "한번 보면 못 빠져나오는 사랑이야기",
                    description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                    isBookmarked: true,
                    bookmarkedCountText: "123"
                ),
                .init(
                    firstPosterImage: nil,
                    secondPosterImage: nil,
                    profileImage: nil,
                    name: "닉네임",
                    title: "한번 보면 못 빠져나오는 사랑이야기",
                    description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                    isBookmarked: false,
                    bookmarkedCountText: "123"
                ),
                .init(
                    firstPosterImage: nil,
                    secondPosterImage: nil,
                    profileImage: nil,
                    name: "닉네임",
                    title: "한번 보면 못 빠져나오는 사랑이야기",
                    description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                    isBookmarked: true,
                    bookmarkedCountText: "123"
                ),
                .init(
                    firstPosterImage: nil,
                    secondPosterImage: nil,
                    profileImage: nil,
                    name: "닉네임",
                    title: "한번 보면 못 빠져나오는 사랑이야기",
                    description: "이 컬렉션은 세계최고 너무나도 멋진 컬렉션입니다",
                    isBookmarked: true,
                    bookmarkedCountText: "123"
                )
                
            ]
        }
    }
}

