//
//  CollectionDetailFilmTableViewCell.swift
//  FLINT
//
//  Created by 진소은 on 1/20/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

public final class CollectionDetailFilmTableViewCell: BaseTableViewCell {

    // MARK: - Property
    
    public var onTapRevealSpoiler: (() -> Void)?

    // MARK: - Component
    
    private let poster = UIImageView().then {
        $0.image = UIImage(resource: .imgBackgroundGradiantLarge)
        $0.layer.cornerRadius = 0
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private let filmInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .leading
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(.head2_sb_20, text: "노트북, The Notebook", color: .white)
    }

    private let yearLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(
            .body1_r_16,
            text: "2005",
            color: .flintGray300,
            lineBreakMode: .byWordWrapping,
            lineBreakStrategy: .hangulWordPriority
        )
        $0.textAlignment = .left
    }

    private let directorLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(.body1_r_16, text: "가스 제닝스", color: .flintGray300)
    }

    private let bookmarkButton = BookmarkView()

    private let dividerView = UIView().then {
        $0.backgroundColor = .flintGray500
    }
    
    private let descriptionContainerView = UIView().then {
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }

    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.attributedText = .pretendard(
            .body1_r_16,
            text: "사랑과 낭만을 꿈꾸게 하는 영화\n-\n개봉한지 20년이 지났음에도 여전히 많은 사람들의 가슴을 뛰게하는 영화\n\n지고지순한 사랑 이야기가 이토록 오래 사랑받을 수 있는 건 누구나 이런 애틋한 사랑을 꿈꾸기 때문이 아닐까?",
            color: .flintGray100,
            lineBreakMode: .byWordWrapping,
            lineBreakStrategy: .hangulWordPriority
        )
    }

    private let spoilerOverlayView = UIView().then {
        $0.isHidden = true
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .clear
    }
    

    private let blurEffectView = VisualEffectView().then {
        $0.blurRadius = 4
        $0.scale = 1
    }

    private let dimView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.12)
    }


    private let overlayStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 12
    }

    private let lockImageView = UIImageView().then {
        $0.image = UIImage(resource: .icLockGradientSmall)
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    private let spoilerLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.attributedText = .pretendard(.body1_m_16, text: "스포일러가 포함된 내용이에요", color: .white)
    }

    private let revealButton = UIButton.flintMoreButton()

    // MARK: - State
    
    private var isSpoiler: Bool = false {
        didSet { spoilerOverlayView.isHidden = !isSpoiler }
    }

    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bind()
    }

    private func bind() {
        revealButton.addTarget(self, action: #selector(didTapReveal), for: .touchUpInside)
    }

    // MARK: - Setup
    
    public override func setStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .flintBackground
        selectionStyle = .none
    }

    public override func setHierarchy() {
        contentView.addSubviews(
            poster,
            filmInfoStackView,
            bookmarkButton,
            dividerView,
            descriptionContainerView
        )

        descriptionContainerView.addSubviews(descriptionLabel)
        
        descriptionContainerView.addSubview(spoilerOverlayView)
        
        filmInfoStackView.addArrangedSubviews(titleLabel, yearLabel, directorLabel)

        spoilerOverlayView.addSubviews(blurEffectView, dimView, overlayStackView)
        overlayStackView.addArrangedSubviews(lockImageView, spoilerLabel, revealButton)
    }

    public override func setLayout() {
        poster.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(poster.snp.width).multipliedBy(1.4)
        }

        bookmarkButton.snp.makeConstraints {
            $0.top.equalTo(poster.snp.bottom).offset(32)
            $0.trailing.equalToSuperview().inset(4)
            $0.width.height.equalTo(48)
        }

        filmInfoStackView.snp.makeConstraints {
            $0.top.equalTo(poster.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(bookmarkButton.snp.leading).offset(-12)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(filmInfoStackView.snp.bottom).offset(24)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        descriptionContainerView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        spoilerOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overlayStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.lessThanOrEqualToSuperview().inset(24)
        }
        
        lockImageView.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }

    // MARK: - Action
    
    @objc private func didTapReveal() {
        onTapRevealSpoiler?()
    }

    // MARK: - Public

    public func configureSpoiler(isSpoiler: Bool) {
        self.isSpoiler = isSpoiler
        
        spoilerOverlayView.isHidden = !isSpoiler
        
        UIView.animate(withDuration: 0.3) {
            self.spoilerOverlayView.alpha = isSpoiler ? 1.0 : 0.0
        }
    }

}

// MARK: - Extension

extension UIButton.Configuration {
    public static func flintMore(title: String = "보기") -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()

        let titleAttr = AttributedString(.pretendard(.head3_m_18, text: "보기"))
        config.attributedTitle = titleAttr
        
        config.image = UIImage(resource: .icMore)
            .withRenderingMode(.alwaysTemplate)
        config.imagePlacement = .trailing

        config.baseForegroundColor = .flintPrimary300
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 0)

        return config
    }
}

extension UIButton {
    public static func flintMoreButton(title: String = "보기") -> UIButton {
        let button = UIButton(configuration: .flintMore(title: title))
        return button
    }
}
