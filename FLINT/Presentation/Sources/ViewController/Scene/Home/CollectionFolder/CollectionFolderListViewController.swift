//
//  CollectionFolderListViewController.swift
//  FLINT
//
//  Created by 소은 on 1/20/26.
//

import UIKit

import View

public final class CollectionFolderListViewController: BaseViewController<CollectionFolderListView> {
    
    // MARK: - Data
    
    private var items: [FolderItem] = FolderItem.mock()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        applyCount()
    }
    
    // MARK: - Override
    
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
    
    private func bind() {
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }
    
    private func applyCount() {
        rootView.countLabel.attributedText = .pretendard(
            .body2_r_14,
            text: "총 \(items.count)개",
            color: DesignSystem.Color.gray100
        )
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionFolderListViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
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
        
        let item = items[indexPath.item]
        
        cell.configure(
            .init(
                firstPosterImage: item.firstPosterImage,
                secondPosterImage: item.secondPosterImage,
                profileImage: item.profileImage,
                name: item.name,
                title: item.title,
                description: item.description,
                isBookmarked: item.isBookmarked,
                bookmarkedCountText: item.bookmarkedCountText
            )
        )
        
        cell.onTapCard = { [weak self] in
            self?.didSelectItem(at: indexPath)
        }
        
        cell.onTapBookmark = { [weak self, weak cell] isBookmarked in
            guard let self, let cell,
                  let indexPath = collectionView.indexPath(for: cell) else { return }

            let wasBookmarked = self.items[indexPath.item].isBookmarked

            self.items[indexPath.item].isBookmarked = isBookmarked

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
