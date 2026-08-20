//
//  CollectionDetailFilmImageTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 5/25/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

public final class CollectionDetailFilmImageTableViewCell: BaseTableViewCell {

    // MARK: - Constants

    private enum Metric {
        static let imageHeight: CGFloat = 270
        static let indicatorTopOffset: CGFloat = 8
        static let indicatorBottomInset: CGFloat = 0
        static let dotSize: CGFloat = 8
        static let dotSpacing: CGFloat = 4
    }

    // MARK: - Property

    private var imageURLs: [URL] = []
    private var isInfinite: Bool = false
    private var currentRealPage: Int = 0
    private var needsInitialOffset: Bool = false

    // MARK: - Component

    private let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.contentInsetAdjustmentBehavior = .never
    }

    private let pageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }

    private let pageIndicatorStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = Metric.dotSpacing
        $0.alignment = .center
        $0.distribution = .fill
    }

    // MARK: - Setup

    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .flintSubBackground
        selectionStyle = .none
        scrollView.delegate = self
    }

    public override func setHierarchy() {
        contentView.addSubviews(scrollView, pageIndicatorStack)
        scrollView.addSubview(pageStackView)
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Metric.imageHeight)
        }

        pageStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide)
        }

        pageIndicatorStack.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(Metric.indicatorTopOffset)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Metric.indicatorBottomInset)
            $0.height.equalTo(Metric.dotSize)
        }
    }

    // MARK: - Lifecycle

    public override func prepare() {
        super.prepare()
        clearImages()
        scrollView.setContentOffset(.zero, animated: false)
        currentRealPage = 0
        isInfinite = false
        needsInitialOffset = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if needsInitialOffset, scrollView.bounds.width > 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
            needsInitialOffset = false
        }
    }

    // MARK: - Private

    private func clearImages() {
        pageStackView.arrangedSubviews.forEach {
            ($0 as? UIImageView)?.kf.cancelDownloadTask()
            pageStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    private func makeImageView(url: URL?) -> UIImageView {
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .flintBackground
        }
        if let url {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(resource: .imgBackgroundGradiantLarge)
        }
        return imageView
    }

    private func setupDots(count: Int) {
        pageIndicatorStack.arrangedSubviews.forEach {
            pageIndicatorStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        (0..<count).forEach { _ in
            let dot = UIView()
            dot.backgroundColor = .flintGray500
            dot.layer.cornerRadius = Metric.dotSize / 2
            dot.snp.makeConstraints { $0.size.equalTo(Metric.dotSize) }
            pageIndicatorStack.addArrangedSubview(dot)
        }
        pageIndicatorStack.isHidden = count <= 1
    }

    private func updateDot(activeIndex: Int) {
        pageIndicatorStack.arrangedSubviews.enumerated().forEach { idx, view in
            view.backgroundColor = (idx == activeIndex) ? .flintSecondary400 : .flintGray500
        }
    }

    private func addImageViewToStack(url: URL?) {
        let imageView = makeImageView(url: url)
        pageStackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
}

// MARK: - Configure

public extension CollectionDetailFilmImageTableViewCell {

    func configure(imageURLs: [URL]) {
        self.imageURLs = imageURLs
        clearImages()

        if imageURLs.count > 1 {
            isInfinite = true
            // 양 끝에 클론을 둬서 무한 스크롤: [last', A, B, C, first']
            addImageViewToStack(url: imageURLs.last)
            imageURLs.forEach { addImageViewToStack(url: $0) }
            addImageViewToStack(url: imageURLs.first)

            setupDots(count: imageURLs.count)
            currentRealPage = 0
            updateDot(activeIndex: 0)

            // 첫 진입 시 실제 첫 이미지(visualPage = 1) 위치로 점프
            needsInitialOffset = true
            setNeedsLayout()
        } else {
            isInfinite = false
            let urls: [URL?] = imageURLs.isEmpty ? [nil] : imageURLs.map { Optional($0) }
            urls.forEach { addImageViewToStack(url: $0) }

            setupDots(count: urls.count)
            currentRealPage = 0
            updateDot(activeIndex: 0)
            scrollView.setContentOffset(.zero, animated: false)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CollectionDetailFilmImageTableViewCell: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        guard width > 0 else { return }
        let visualPage = Int((scrollView.contentOffset.x + width / 2) / width)

        if isInfinite {
            let totalCount = imageURLs.count
            let realPage: Int
            if visualPage <= 0 {
                realPage = totalCount - 1
            } else if visualPage >= totalCount + 1 {
                realPage = 0
            } else {
                realPage = visualPage - 1
            }
            if currentRealPage != realPage {
                currentRealPage = realPage
                updateDot(activeIndex: realPage)
            }
        } else {
            if currentRealPage != visualPage {
                currentRealPage = visualPage
                updateDot(activeIndex: visualPage)
            }
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        jumpIfOnClone(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        jumpIfOnClone(scrollView)
    }

    private func jumpIfOnClone(_ scrollView: UIScrollView) {
        guard isInfinite else { return }
        let width = scrollView.bounds.width
        guard width > 0 else { return }
        let visualPage = Int((scrollView.contentOffset.x + width / 2) / width)
        let totalCount = imageURLs.count
        if visualPage == 0 {
            // last 클론에 도달 → 실제 last(visualPage = totalCount)로 점프
            scrollView.setContentOffset(CGPoint(x: width * CGFloat(totalCount), y: 0), animated: false)
        } else if visualPage == totalCount + 1 {
            // first 클론에 도달 → 실제 first(visualPage = 1)로 점프
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        }
    }
}
