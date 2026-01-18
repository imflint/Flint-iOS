//
//  PreferenceExampleView.swift
//  FLINT
//
//  Created by 진소은 on 1/18/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PreferenceExampleView: BaseView {

    private let titleLabel = UILabel().then {
        $0.attributedText = .pretendard(.head1_sb_22, text: "Preference Chips (Test)", color: .white)
    }

    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }

    private let contentView = UIView()

    private let chipStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
    }

    override func setHierarchy() {
        addSubviews(titleLabel, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(chipStackView)
        
        let dummyData: [KeywordDTO] = [
            .init(color: .orange, rank: 1, name: "힐링", percentage: 85, imageUrl: "https://picsum.photos/seed/heal/80"),
            .init(color: .green,  rank: 2, name: "설레는", percentage: 72, imageUrl: "https://picsum.photos/seed/excite/80"),
            .init(color: .blue,   rank: 3, name: "잔잔한", percentage: 61, imageUrl: "https://picsum.photos/seed/calm/80"),
            .init(color: .yellow, rank: 4, name: "디스토피아ㅏㅏㅏㅏㅏ", percentage: 55, imageUrl: "https://picsum.photos/seed/pop/80"),
            .init(color: .pink,   rank: 5, name: "로맨틱", percentage: 49, imageUrl: "https://picsum.photos/seed/romance/80")
        ]

        chipStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        dummyData.forEach { dto in
            let chip = PreferenceChip()
            chip.configure(dto: dto)

            chipStackView.addArrangedSubview(chip)
        }
    }

    override func setLayout() {
        backgroundColor = .flintGray500
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(16)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        chipStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            $0.height.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    PreferenceExampleView()
}
