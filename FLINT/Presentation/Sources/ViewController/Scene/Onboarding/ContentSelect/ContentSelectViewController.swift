//
//  ContentSelectViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.14.
//

import UIKit

import SnapKit

import Domain

import View
import ViewModel

public protocol ContentSelectViewControllerFactory {
    func makeContentSelectViewController(onboardingViewModel: OnboardingViewModel) -> ContentSelectViewController
}

public final class ContentSelectViewController: BaseViewController<ContentSelectView> {
    
    // MARK: - Enum
    
    private enum FoldableViewAction {
        case reveal
        case hide
        
        init?(velocity: CGFloat) {
            if velocity > 0 {
                self = .reveal
            } else {
                self = .hide
            }
        }
    }
    
    // MARK: - ViewModel
    
    private let onboardingViewModel: OnboardingViewModel
    
    // MARK: - DataSource
    
    private var contentCollectionViewDataSource: ContentCollectionViewDataSource?
    private var selectedContentCollectionViewDataSource: SelectedContentCollectionViewDataSource?
    private var genreCollectionViewDataSource: GenreCollectionViewDataSource?
    
    // MARK: - Property
    
    private var offsetCorrection: CGFloat = 0
    private var foldableViewYOffset: CGFloat = 0
    
    // MARK: - Basic
    
    public init(onboardingViewModel: OnboardingViewModel, viewControllerFactory: ViewControllerFactory) {
        self.onboardingViewModel = onboardingViewModel
        super.init(viewControllerFactory: viewControllerFactory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(left: .back, backgroundStyle: .solid(DesignSystem.Color.background)))
        hideKeyboardWhenTappedAround(activeOnAction: false)
        
        onboardingViewModel.fetchPopularContents()
        
        setupTextField()
        setupContentCollectionView()
        setupSelectedContentCollectionView()
        setupGenreCollectionView()
        
        rootView.layoutIfNeeded()
        rootView.contentCollectionView.contentOffset.y = -rootView.contentCollectionView.contentInset.top
        
        rootView.nextButton.addAction(UIAction(weak: self, handler: ContentSelectViewController.touchUpInsideNextButton(_:)), for: .touchUpInside)
    }
    
    public override func bind() {
        onboardingViewModel.isLoading.sink { [weak self] isLoading in
            Log.d(isLoading)
            guard let self else { return }
            if isLoading && onboardingViewModel.contents.value.isEmpty {
                rootView.emptyView.isHidden = true
                rootView.loadingIndicator.startAnimating()
            } else {
                rootView.loadingIndicator.stopAnimating()
            }
        }
        .store(in: &cancellables)
        
        onboardingViewModel.nickname.sink { [weak self] nickname in
            guard let self else { return }
            rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "\(onboardingViewModel.nickname.value) 님이 좋아하는 작품 7개를 골라주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        }
        .store(in: &cancellables)
        
        onboardingViewModel.contents.sink { [weak self] contents in
            guard let self else { return }
            rootView.emptyView.isHidden = !contents.isEmpty || onboardingViewModel.isLoading.value
            contentCollectionViewDataSource?.apply(makeContentCollectionViewSnapshot(contentEntities: contents), animatingDifferences: false)
        }
        .store(in: &cancellables)
        
        onboardingViewModel.selectedContents.sink { [weak self] selectedContents in
            guard let self else { return }
            rootView.searchView.clipsToBounds = !selectedContents.isEmpty
            UIView.animate(withDuration: 0.2, animations: {
                self.rootView.selectedContentCollectionView.isHidden = selectedContents.isEmpty
            })
            selectedContentCollectionViewDataSource?.apply(makeSelectedContentCollectionViewSnapshot(contentEntities: selectedContents), animatingDifferences: false)
            
            guard var snapshot = contentCollectionViewDataSource?.snapshot() else { return }
            snapshot.reconfigureItems(snapshot.itemIdentifiers)
            contentCollectionViewDataSource?.apply(snapshot, animatingDifferences: false)
            
            rootView.progressLabel.attributedText = .pretendard(.caption1_m_12, text: "\(selectedContents.count)/\(onboardingViewModel.requiredContentCount)")
            rootView.progressView.progress = Float(selectedContents.count) / Float(onboardingViewModel.requiredContentCount)
            
            rootView.nextButton.isEnabled = selectedContents.count == 7
        }
        .store(in: &cancellables)
    }
    
    private func touchUpInsideNextButton(_ action: UIAction) {
        guard let nicknameViewController = viewControllerFactory?.makeNicknameViewController(onboardingViewModel: onboardingViewModel) else { return }
        navigationController?.pushViewController(nicknameViewController, animated: true)
    }
}

// MARK: - UICollectionView Delegate

extension ContentSelectViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === rootView.contentCollectionView {
            contentCollectionView(collectionView, didSelectItemAt: indexPath)
        } else if collectionView === rootView.genreCollectionView {
            genreCollectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}

// MARK: - ContentCollectionView

extension ContentSelectViewController {
    
    private typealias ContentCollectionViewDataSource = UICollectionViewDiffableDataSource<ContentCollectionViewSection, ContentCollectionViewItem>
    private typealias ContentCollectionViewSnapshot = NSDiffableDataSourceSnapshot<ContentCollectionViewSection, ContentCollectionViewItem>
    
    private enum ContentCollectionViewSection: Int {
        case main
    }
    
    private enum ContentCollectionViewItem: Hashable, Sendable {
        case content(ContentEntity)
    }
    
    private func setupContentCollectionView() {
        rootView.contentCollectionView.delegate = self
        rootView.contentCollectionView.dataSource = contentCollectionViewDataSource
        
        contentCollectionViewDataSource = ContentCollectionViewDataSource(collectionView: rootView.contentCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            
            switch itemIdentifier {
            case .content(let content):
                let cell = collectionView.dequeueReusableCell(OnboardingContentCollectionViewCell.self, for: indexPath)
                let isSelected = onboardingViewModel.selectedContents.value.contains(where: {
                    $0 == content
                })
                cell.configure(content: content, isSelected: isSelected)
                return cell
            }
        })
        contentCollectionViewDataSource?.apply(makeContentCollectionViewSnapshot(contentEntities: onboardingViewModel.contents.value), animatingDifferences: false)
        
        rootView.contentCollectionView.panGestureRecognizer.addTarget(self, action: #selector(contentCollectionViewPanGesture))
    }
    
    private func makeContentCollectionViewSnapshot(contentEntities: [ContentEntity]) -> ContentCollectionViewSnapshot {
        var snapshot = ContentCollectionViewSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(contentEntities.map({ ContentCollectionViewItem.content($0) }), toSection: .main)
        return snapshot
    }
    
    public func contentCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard onboardingViewModel.selectedContents.value.count <= 6 else { return }
        onboardingViewModel.clickContent(onboardingViewModel.contents.value[indexPath.item])
    }
    
    @objc public func contentCollectionViewPanGesture(_ sender: UIPanGestureRecognizer) {
        // Adjust the accumulated scroll translation
        // so that the foldableView responds immediately when the scroll direction changes
        let translationY = sender.translation(in: rootView.contentCollectionView).y
        let velocityY = sender.velocity(in: rootView.contentCollectionView).y
        
        let unclampedOffset = translationY - offsetCorrection
        
        // Update offsetCorrection value
        if unclampedOffset >= 0 {
            // When foldableView is visible
            // foldableViewYOffset = translationY - offsetCorrection = 0
            offsetCorrection = translationY
        }
        if unclampedOffset <= -rootView.foldableView.bounds.height {
            // When foldableView is hidden
            // foldableViewYOffset = translationY - offsetCorrection = -rootView.foldableView.bounds.height
            offsetCorrection = translationY + rootView.foldableView.bounds.height
        }
        let passedFoldableViewYOffset = foldableViewYOffset
        foldableViewYOffset = translationY - offsetCorrection
        rootView.updateFoldableViewYOffset(foldableViewYOffset)
        rootView.contentCollectionView.contentOffset.y += foldableViewYOffset - passedFoldableViewYOffset
        rootView.foldableView.alpha = 1 + foldableViewYOffset / rootView.foldableView.bounds.height
        
        // Magnetic snapping effect when the gesture ends
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self else { return }
                switch FoldableViewAction(velocity: velocityY) {
                case .reveal:
                    foldableViewYOffset = .zero
                    rootView.updateFoldableViewYOffset(foldableViewYOffset)
                    offsetCorrection = .zero
                    rootView.foldableView.alpha = 1
                case .hide:
                    foldableViewYOffset = -rootView.foldableView.bounds.height
                    rootView.updateFoldableViewYOffset(foldableViewYOffset)
                    offsetCorrection = rootView.foldableView.bounds.height
                    rootView.foldableView.alpha = .zero
                case nil:
                    break
                }
                rootView.layoutIfNeeded()
            })
        }
    }
}

// MARK: - SelectedContentCollectionView

extension ContentSelectViewController {
    
    private typealias SelectedContentCollectionViewDataSource = UICollectionViewDiffableDataSource<SelectedContentCollectionViewSection, SelectedContentCollectionViewItem>
    private typealias SelectedContentCollectionViewSnapshot = NSDiffableDataSourceSnapshot<SelectedContentCollectionViewSection, SelectedContentCollectionViewItem>
    
    private enum SelectedContentCollectionViewSection: Int {
        case main
    }
    
    private enum SelectedContentCollectionViewItem: Hashable, Sendable {
        case content(ContentEntity)
    }
    
    private func setupSelectedContentCollectionView() {
        rootView.selectedContentCollectionView.dataSource = selectedContentCollectionViewDataSource
        
        selectedContentCollectionViewDataSource = SelectedContentCollectionViewDataSource(collectionView: rootView.selectedContentCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .content(let content):
                let cell = collectionView.dequeueReusableCell(SelectedContentCollectionViewCell.self, for: indexPath)
                cell.imageView.kf.setImage(with: content.posterUrl)
                cell.xButton.addAction(UIAction(handler: { [weak self] _ in
                    self?.onboardingViewModel.deleteContent(content)
                }), for: .touchUpInside)
                return cell
            }
        })
        selectedContentCollectionViewDataSource?.apply(makeSelectedContentCollectionViewSnapshot(contentEntities: onboardingViewModel.selectedContents.value))
    }
    
    private func makeSelectedContentCollectionViewSnapshot(contentEntities: [ContentEntity]) -> SelectedContentCollectionViewSnapshot {
        var snapshot = SelectedContentCollectionViewSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(contentEntities.map({ SelectedContentCollectionViewItem.content($0) }), toSection: .main)
        return snapshot
    }
}

// MARK: - GenreCollectionView

extension ContentSelectViewController {
    private typealias GenreCollectionViewDataSource = UICollectionViewDiffableDataSource<GenreCollectionViewSection, GenreCollectionViewItem>
    private typealias GenreCollectionViewSnapshot = NSDiffableDataSourceSnapshot<GenreCollectionViewSection, GenreCollectionViewItem>
    
    private enum GenreCollectionViewSection: Int {
        case main
    }
    
    private enum GenreCollectionViewItem: Hashable, Sendable {
        case genre(Genre)
    }
    
    private func setupGenreCollectionView() {
        rootView.genreCollectionView.delegate = self
        rootView.genreCollectionView.dataSource = genreCollectionViewDataSource
        
        genreCollectionViewDataSource = GenreCollectionViewDataSource(collectionView: rootView.genreCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .genre(genre):
                let cell = collectionView.dequeueReusableCell(GenreCollectionViewCell.self, for: indexPath)
                cell.configure(genre: genre)
//                cell.capsuleButton.addAction(UIAction(handler: { _ in
//                    Log.d(indexPath)
//                    cell.capsuleButton.isSelected.toggle()
//                }), for: .touchUpInside)
                return cell
            }
        })
        genreCollectionViewDataSource?.apply(makeGenreCollectionViewSnapshot())
    }
    
    private func makeGenreCollectionViewSnapshot() -> GenreCollectionViewSnapshot {
        var snapshot = GenreCollectionViewSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(Genre.allCases.map { GenreCollectionViewItem.genre($0) }, toSection: .main)
        return snapshot
    }
    
    public func genreCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onboardingViewModel.filterGenre.value.insert(Genre.allCases[indexPath.row])
        Log.d(onboardingViewModel.filterGenre.value)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        onboardingViewModel.filterGenre.value.remove(Genre.allCases[indexPath.row])
        Log.d(onboardingViewModel.filterGenre.value)
    }
}

// MARK: - SearchTextField

extension ContentSelectViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return true }
        onboardingViewModel.keyword.send(text)
        return true
    }
    
    private func setupTextField() {
        rootView.searchTextField.searchAction = { [weak self] keyword in
            self?.onboardingViewModel.keyword.send(keyword)
        }
        rootView.searchTextField.clearAction = { [weak self] in
            self?.onboardingViewModel.fetchPopularContents()
        }
        
        rootView.searchTextField.delegate = self
    }
}
