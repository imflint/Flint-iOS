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
    
    // MARK: - Metric
    
    private enum Metric {
        static let posterTop: CGFloat = 64
        static let posterLeading: CGFloat = 16
        static let posterWidth: CGFloat = 100
        static let posterHeight: CGFloat = 150
        static let photoHeight: CGFloat = 270
        static let horizontalInset: CGFloat = 16
    }
    
    // MARK: - Closure
    
    public var onTapClose: (() -> Void)?
    public var onToggleSpoiler: ((Bool) -> Void)?
    public var onChangeReasonText: ((String) -> Void)?
    public var onTapCloseWithDraft: (() -> Void)?
    public var onTapAddPhoto: (() -> Void)?
    public var onPhotosChanged: (() -> Void)?
    
    public var currentReasonText: String { textView.text ?? "" }
    public var currentPhotos: [UIImage] { photos }
    
    // MARK: - State
    
    private var photos: [UIImage] = []
    private var photoScrollHeightConstraint: Constraint?
    private var pageControlTopConstraint: Constraint?
    private var pageControlHeightConstraint: Constraint?
    
    // MARK: - UI
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(.icPrimaryXmark, for: .normal)
    }
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let infoContainerView = UIView().then {
        $0.backgroundColor = .clear
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
    
    private let sectionTitleLabel = UILabel()
    
    private let textView = FlintTextView(placeholder: "이 작품의 매력 포인트를 적어주세요.")
    
    private let addPhotoButton = UIButton().then {
        $0.setImage(.icAddPhoto, for: .normal)
    }
    
    private let spoilerLabel = UILabel()
    
    private let checkboxToggleView = ToggleBarView(
        type: .primary,
        isOn: false,
        knobSize: 24,
        contentInset: 2
    )
    
    // MARK: - Setup
    
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
        textView.delegate = self
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
            closeButton
        )
        
        infoContainerView.addSubviews(titleLabel, directorLabel, yearLabel)
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
        
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Metric.posterTop)
            $0.leading.equalToSuperview().inset(Metric.posterLeading)
            $0.width.equalTo(Metric.posterWidth)
            $0.height.equalTo(Metric.posterHeight)
        }
        
        infoContainerView.snp.makeConstraints {
            $0.top.equalTo(posterImageView)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        photoScrollView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
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
        
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(Metric.horizontalInset)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(Metric.horizontalInset)
            $0.height.greaterThanOrEqualTo(104)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.centerY.equalTo(checkboxToggleView)
            $0.leading.equalToSuperview().inset(Metric.horizontalInset)
            $0.width.equalTo(48)
            $0.height.equalTo(28)
        }
        
        checkboxToggleView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(Metric.horizontalInset)
            $0.width.equalTo(44)
            $0.height.equalTo(28)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        spoilerLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkboxToggleView)
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
        resetPhotos()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        resetPhotos()
    }
    
    // MARK: - Configure
    
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
        
        if textView.text.isEmpty || textView.text != item.reasonText {
            textView.text = item.reasonText ?? ""
            textView.subviews.compactMap { $0 as? UILabel }.first?.isHidden = !(item.reasonText ?? "").isEmpty
        }
    
        configurePhotos(item.photos)
    }
    
    // MARK: - Private
    
    private var isSpoilerOn: Bool = false
    
    private func resetPhotos() {
        photos = []
        photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        applyPhotoLayout(hasPhotos: false)
    }
    
    private func configurePhotos(_ newPhotos: [UIImage]) {
        photos = newPhotos
        photoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        applyPhotoLayout(hasPhotos: !photos.isEmpty)
        guard !photos.isEmpty else { return }
        
        pageControl.numberOfPages = photos.count
        pageControl.currentPage = 0
        
        setupInfiniteScroll()
    }
    
    private func setupInfiniteScroll() {
        let infinitePhotos = [photos.last!] + photos + [photos.first!]
        
        infinitePhotos.enumerated().forEach { index, image in
            let realIndex: Int
            if index == 0 { realIndex = photos.count - 1 }
            else if index == photos.count + 1 { realIndex = 0 }
            else { realIndex = index - 1 }
            
            photoStackView.addArrangedSubview(makePhotoWrapper(image: image, realIndex: realIndex))
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
            let width = self.photoScrollView.bounds.width
            guard width > 0 else { return }
            self.photoScrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        }
    }
    
    private func applyPhotoLayout(hasPhotos: Bool) {
        photoScrollView.isHidden = !hasPhotos
        photoScrollHeightConstraint?.update(offset: hasPhotos ? Metric.photoHeight : 0)
        pageControl.isHidden = !hasPhotos
        pageControlTopConstraint?.update(offset: hasPhotos ? 8 : 0)
        pageControlHeightConstraint?.update(offset: hasPhotos ? 8 : 0)
        
        sectionTitleLabel.snp.remakeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(Metric.horizontalInset)
        }
    }
    
    private func makePhotoWrapper(image: UIImage, realIndex: Int) -> UIView {
        let wrapper = UIView().then {
            $0.clipsToBounds = true
            $0.backgroundColor = .flintGray800
        }
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.image = image
        }
        
        let deleteButton = UIButton().then {
            $0.setImage(.icBlackXmark, for: .normal)
            $0.tag = realIndex
            $0.addTarget(self, action: #selector(didTapDeletePhoto(_:)), for: .touchUpInside)
        }
        
        wrapper.addSubviews(imageView, deleteButton)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(48)
        }
        
        wrapper.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(Metric.photoHeight)
        }
        
        return wrapper
    }
    
    // MARK: - Action
    
    @objc private func didTapClose() {
        let text = (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        text.isEmpty ? onTapClose?() : onTapCloseWithDraft?()
    }
    
    @objc private func didTapAddPhoto() {
        onTapAddPhoto?()
    }
    
    @objc private func didTapDeletePhoto(_ sender: UIButton) {
        let index = sender.tag
        guard index < photos.count else { return }
        photos.remove(at: index)
        configurePhotos(photos)
        onPhotosChanged?()
    }
}

// MARK: - UIScrollViewDelegate

extension SelectedContentReasonTableViewCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        guard width > 0, !photos.isEmpty else { return }
        let page = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = (page - 1 + photos.count) % photos.count
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        guard width > 0, !photos.isEmpty else { return }
        let page = Int(round(scrollView.contentOffset.x / width))
        
        if page == 0 {
            scrollView.setContentOffset(CGPoint(x: width * CGFloat(photos.count), y: 0), animated: false)
        } else if page == photos.count + 1 {
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        }
        
    }
    
}

extension SelectedContentReasonTableViewCell: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if let flintTextView = textView as? FlintTextView {
            let placeholderLabel = flintTextView.subviews.compactMap { $0 as? UILabel }.first
            placeholderLabel?.isHidden = !textView.text.isEmpty
        }
        onChangeReasonText?(textView.text ?? "")
    }
}

public extension SelectedContentReasonTableViewCell {
    func setError(_ isError: Bool) {
        textView.layer.borderColor = isError ? DesignSystem.Color.error500.cgColor : UIColor.clear.cgColor
        textView.layer.borderWidth = isError ? 1 : 0
        textView.layer.cornerRadius = 8
    }
}
