//
//  TermAgreementCollectionViewCell.swift
//  Presentation
//
//  Created by 김호성 on 2026.05.30.
//

import UIKit

import Domain

package final class TermAgreementCollectionViewCell: BaseCollectionViewListCell {
    
    // MARK: - Component
    
    package let termAgreeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    package let termAgreeHeaderView = UIView()
    package let termAgreeCheckbox = FlintCheckbox()
    package let termAgreeLabel = UILabel().then {
        $0.textColor = .flintWhite
    }
    
    package lazy var expandButton = UIButton().then {
        $0.setImage(.icDown, for: .normal)
        $0.setImage(.icUp, for: .selected)
        $0.addTarget(self, action: #selector(touchUpInsideExpandButton(_:)), for: .touchUpInside)
    }
    
    package let termDetailView = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 8
        $0.isHidden = true
    }
    package let termDetailLabel = UILabel().then {
        $0.textColor = .flintWhite
        $0.numberOfLines = 0
    }
    package let termDetailMoreButton = UIButton().then {
        $0.setAttributedTitle(
            NSMutableAttributedString(.pretendard(.body2_r_14, text: "자세히 보기")).configured {
                $0.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: $0.length))
            },
            for: .normal
        )
        $0.setTitleColor(.flintPrimary200, for: .normal)
    }
    
    // MARK: - Basic
    
    package override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .flintBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    package override func prepare() {
        termAgreeCheckbox.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    // MARK: - Setup
    
    package override func setHierarchy() {
        contentView.addSubview(termAgreeStackView)
        termAgreeStackView.addArrangedSubviews(
            termAgreeHeaderView,
            termDetailView
        )
        termAgreeHeaderView.addSubviews(
            termAgreeCheckbox,
            termAgreeLabel,
            expandButton,
        )
        termDetailView.addSubviews(
            termDetailLabel,
            termDetailMoreButton
        )
    }
    
    package override func setLayout() {
        termAgreeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        termAgreeCheckbox.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.leading.verticalEdges.equalToSuperview()
        }
        termAgreeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(termAgreeCheckbox.snp.trailing)
        }
        expandButton.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.trailing.verticalEdges.equalToSuperview()
        }
        termDetailLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(12)
        }
        termDetailMoreButton.snp.makeConstraints {
            $0.top.equalTo(termDetailLabel.snp.bottom)
            $0.height.equalTo(48)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Public Function
    
    package func configure(_ signUpTerm: SignUpTerm) {
        termAgreeLabel.attributedText = .pretendard(.body1_r_16, text: signUpTerm.title)
        termDetailLabel.attributedText = .pretendard(.body2_r_14, text: signUpTerm.description)
    }
    
    // MARK: - Private Function
    
    @objc private func touchUpInsideExpandButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        termDetailView.isHidden = !sender.isSelected
        invalidateIntrinsicContentSize()
    }
}
