//
//  SelectedContentReasonTableViewCell.swift
//  FLINT
//
//  Created by 소은 on 1/17/26.
//

import UIKit

import SnapKit
import Then

public final class SelectedContentReasonTableViewCell: BaseTableViewCell {
    
    public var onTapClose: (() -> Void)?
    public var onToggleSpoiler: ((Bool) -> Void)?
    public var onChangeReasonText: ((String) -> Void)?
    public var onTapCloseWithDraft: (() -> Void)?
    public var onTapAddPhoto: (() -> Void)?
    
    private var isSpoilerOn: Bool = false
    private var photos: [UIImage] = []
    
    private var photoScrollHeightConstraint: Constraint?
    private var pageControlTopConstraint: Constraint?
    private var pageControlHeightConstraint: Constraint?
    
    //MARK: - UI
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let infoContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(.icPrimaryXmark, for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let directorLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let yearLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    private let sectionTitleLabel = UILabel()
    private let spoilerLabel = UILabel()
    
    private let textView = FlintTextView(placeholder: "이 작품의 매력 포인트를 적어주세요.")
    
    private let photoScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.isHidden = true
    }
    
    private let photoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
    }
    
    private let pageControl = CustomPageControl().then {
        $0.isHidden = true
    }
    
    private let addPhotoButton = UIButton().then {
        $0.setImage(.icAddPhoto, for: .normal)
    }
    
    private let checkboxToggleView = ToggleBarView(
        type: .primary,
        isOn: false,
        knobSize: 24,
        contentInset: 2
    )
    
    //MARK: - Setup
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        sectionTitleLabel.attributedText = .pretendard(.head3_m_18, text: "이 작품을 선택한 이유", color: .flintWhite)
        spoilerLabel.attributedText = .pretendard(.caption1_m_12, text: "스포일러", color: .flintWhite)
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(didTapAddPhoto), for: .touchUpInside)
        
        photoScrollView.delegate = self
        
        checkboxToggleView.onValueChanged = { [weak self] isOn in
            self?.onToggleSpoiler?(isOn)
        }
    }
    
    public override func setHierarchy() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews(
            posterImageView,
            infoContainerView,
            photoScrollView,
            pageControl,
            sectionTitleLabel,
            textView,
            addPhotoButton,
            spoilerLabel,
            checkboxToggleView,
            closeButton  // 항상 최상단
        )
        
        infoContainerView.addSubviews(
            titleLabel,
            directorLabel,
            yearLabel
        )
        
        photoScrollView.addSubview(photoStackView)
    }
    
    public override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        photoScrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            photoScrollHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        photoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            pageControlTopConstraint = $0.top.equalTo(photoScrollView.snp.bottom).offset(0).constraint
            $0.centerX.equalToSuperview()
            pageControlHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(64)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        infoContainerView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(104)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.centerY.equalTo(checkboxToggleView.snp.centerY)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(48)
            $0.height.equalTo(28)
        }
        
        checkboxToggleView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(44)
            $0.height.equalTo(28)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        spoilerLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkboxToggleView.snp.centerY)
            $0.trailing.equalTo(checkboxToggleView.snp.leading).offset(-8)
        }
    }
    
    public override func prepare() {
        super.prepare()
        
        posterImageView.image = nil
        titleLabel.attributedText = nil
        directorLabel.attributedText = nil
        yearLabel.attributedText = nil
        
        isSpoilerOn = false
        checkboxToggleView.setOn(false, animated: true)
        textView.text = ""
        
        photos = []
        photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        applyLayout(hasPhotos: false)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        photos = []
        photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        applyLayout(hasPhotos: false)
    }
    
    //MARK: - Configure
    
    public func configure(with item: SelectedContentReasonTableViewCellItem) {
        if let url = item.posterURL {
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = item.posterImage
        }
        
        titleLabel.attributedText = .pretendard(.head3_m_18, text: item.title, color: .flintWhite)
        directorLabel.attributedText = .pretendard(.body1_r_16, text: item.director, color: .flintGray300)
        yearLabel.attributedText = .pretendard(.body1_r_16, text: item.year, color: .flintGray300)
        
        sectionTitleLabel.attributedText = .pretendard(.head3_m_18, text: "이 작품을 선택한 이유", color: .flintWhite)
        spoilerLabel.attributedText = .pretendard(.caption1_m_12, text: "스포일러", color: .flintWhite)
        
        checkboxToggleView.setOn(item.isSpoiler, animated: false)
        textView.text = item.reasonText ?? ""
        
        configurePhotos(item.photos)
    }
    
    private func configurePhotos(_ newPhotos: [UIImage]) {
        photos = newPhotos
        photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let hasPhotos = !photos.isEmpty
        applyLayout(hasPhotos: hasPhotos)
        
        guard hasPhotos else { return }
        
        pageControl.numberOfPages = photos.count
        pageControl.currentPage = 0
        
        photos.enumerated().forEach { index, image in
            let wrapper = makePhotoWrapper(image: image, index: index)
            photoStackView.addArrangedSubview(wrapper)
        }
    }
    
    private func applyLayout(hasPhotos: Bool) {
        if hasPhotos {
            posterImageView.isHidden = true
            infoContainerView.isHidden = false  // 유지
            
            photoScrollView.isHidden = false
            photoScrollHeightConstraint?.update(offset: 270)
            
            pageControl.isHidden = false
            pageControlTopConstraint?.update(offset: 8)
            pageControlHeightConstraint?.update(offset: 8)
            
            // infoContainerView → photoScrollView 기준
            infoContainerView.snp.remakeConstraints {
                $0.top.equalTo(photoScrollView.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            
            sectionTitleLabel.snp.remakeConstraints {
                $0.top.equalTo(infoContainerView.snp.bottom).offset(16)
                $0.leading.equalToSuperview().inset(16)
            }
            
        } else {
            posterImageView.isHidden = false
            infoContainerView.isHidden = false
            
            photoScrollView.isHidden = true
            photoScrollHeightConstraint?.update(offset: 0)
            
            pageControl.isHidden = true
            pageControlTopConstraint?.update(offset: 0)
            pageControlHeightConstraint?.update(offset: 0)
            
            // infoContainerView → posterImageView 기준 (원래대로)
            infoContainerView.snp.remakeConstraints {
                $0.top.equalTo(posterImageView.snp.top)
                $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
                $0.trailing.equalToSuperview().inset(24)
            }
            
            sectionTitleLabel.snp.remakeConstraints {
                $0.top.equalTo(posterImageView.snp.bottom).offset(16)
                $0.leading.equalToSuperview().inset(16)
            }
        }
    }
    
    private func makePhotoWrapper(image: UIImage, index: Int) -> UIView {
        let wrapper = UIView().then {
            $0.clipsToBounds = true
        }
        
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = image
        }
        
        let deleteButton = UIButton().then {
            $0.setImage(.icDeselect, for: .normal)
            $0.tag = index
            $0.addTarget(self, action: #selector(didTapDeletePhoto(_:)), for: .touchUpInside)
        }
        
        wrapper.addSubview(imageView)
        wrapper.addSubview(deleteButton)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(48)
        }
        
        wrapper.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(270)
        }
        
        return wrapper
    }
    
    //MARK: - Action
    
    @objc private func didTapClose() {
        let text = (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            onTapClose?()
        } else {
            onTapCloseWithDraft?()
        }
    }
    
    @objc private func didTapAddPhoto() {
        onTapAddPhoto?()
    }
    
    @objc private func didTapDeletePhoto(_ sender: UIButton) {
        let index = sender.tag
        guard index < photos.count else { return }
        photos.remove(at: index)
        configurePhotos(photos)
    }
}

// MARK: - UIScrollViewDelegate

extension SelectedContentReasonTableViewCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
    }
}


#if DEBUG
import UIKit
import PhotosUI

public final class SelectedContentReasonPreviewViewController: UIViewController {
    
    private let tableView = UITableView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(
            SelectedContentReasonTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension SelectedContentReasonPreviewViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as! SelectedContentReasonTableViewCell
        cell.configure(with: .mock)
        cell.onTapAddPhoto = { [weak self] in
            var config = PHPickerConfiguration()
            config.selectionLimit = 5
            config.filter = .images
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self?.present(picker, animated: true)
        }
        return cell
    }
}

extension SelectedContentReasonPreviewViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SelectedContentReasonTableViewCell else { return }
        
        let group = DispatchGroup()
        var images: [UIImage] = []
        let lock = NSLock()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                if let image = object as? UIImage {
                    lock.lock()
                    images.append(image)
                    lock.unlock()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            var item = SelectedContentReasonTableViewCellItem.mock
            item.photos = images
            cell.configure(with: item)
            
            // 셀 높이 재계산
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
    }
}
#endif
