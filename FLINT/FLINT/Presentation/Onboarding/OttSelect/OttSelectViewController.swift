//
//  OttSelectViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

class OttSelectViewController: BaseViewController<OttSelectView> {
    
    // TODO: - Temp Enum Ott / Ott 관련 enum이 여러개 있어서 저도 일단 내부 선언 해두고 나중에 리팩해서 하나로 합칠게요.
    
    enum Ott: Int, CaseIterable {
        case netflix
        case tving
        case coupangPlay
        case wavve
        case disneyPlus
        case watchapedia
        
        var korTitle: String {
            switch self {
            case .netflix:
                return "넷플릭스"
            case .tving:
                return "티빙"
            case .coupangPlay:
                return "쿠팡플레이"
            case .wavve:
                return "웨이브"
            case .disneyPlus:
                return "디즈니플러스"
            case .watchapedia:
                return "왓챠피디아"
            }
        }
        
        var image: UIImage {
            switch self {
            case .netflix:
                return .imgNetflix
            case .tving:
                return .imgTving
            case .coupangPlay:
                return .imgCoupang
            case .wavve:
                return .imgWave
            case .disneyPlus:
                return .imgDisney
            case .watchapedia:
                return .imgWatcha
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(.init(left: .back, right: .text(title: "건너뛰기", color: .flintSecondary400)))
        rootView.titleLabel.attributedText = .pretendard(.display2_m_28, text: "얀비 님이 구독 중인 OTT 서비스를 알려주세요", lineBreakMode: .byWordWrapping, lineBreakStrategy: .hangulWordPriority)
        rootView.filmCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource

extension OttSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Ott.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingOttCollectionViewCell.reuseIdentifier, for: indexPath) as? OnboardingOttCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let ott = Ott(rawValue: indexPath.item) else {
            return cell
        }
        cell.imageView.image = ott.image
        cell.titleLabel.attributedText = .pretendard(.body1_m_16, text: ott.korTitle, alignment: .center)
        return cell
    }
}
