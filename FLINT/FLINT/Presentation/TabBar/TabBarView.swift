//
//  TabBarView.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.15.
//

import UIKit

import SnapKit
import Then

class TabBarView: BaseView {
    
    // MARK: - Enum
    
    enum Tab {
        case home
        case explore
        case my
        
        var icon: UIImage {
            switch self {
            case .home:
                return .icHomeEmpty
            case .explore:
                return .icExploreEmpty
            case .my:
                return .icMyEmpty
            }
        }
        
        var title: String {
            switch self {
            case .home:
                return "홈"
            case .explore:
                return "탐색"
            case .my:
                return "MY"
            }
        }
    }
    
    // MARK: - Property
    
    var selectedTab: Tab = .home {
        didSet {
            switch selectedTab {
            case .home:
                homeButton.isSelected = true
                exploreButton.isSelected = false
                myButton.isSelected = false
            case .explore:
                homeButton.isSelected = false
                exploreButton.isSelected = true
                myButton.isSelected = false
            case .my:
                homeButton.isSelected = false
                exploreButton.isSelected = false
                myButton.isSelected = true
            }
        }
    }
    
    // MARK: - Component
    
    let tabBarBackgroundView = UIView().then {
        $0.backgroundColor = .flintGray800
        $0.layer.cornerRadius = 12
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    let homeButton = UIButton().then {
        $0.setTabButton(tab: .home)
    }
    let exploreButton = UIButton().then {
        $0.setTabButton(tab: .explore)
    }
    let myButton = UIButton().then {
        $0.setTabButton(tab: .my)
    }
    
    // MARK: - Basic
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setUI() {
        backgroundColor = .clear
    }
    
    override func setHierarchy() {
        addSubviews(tabBarBackgroundView)
        tabBarBackgroundView.addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(
            homeButton,
            exploreButton,
            myButton
        )
    }
    
    override func setLayout() {
        tabBarBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(39)
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension UIButton {
    fileprivate func setTabButton(tab: TabBarView.Tab) {
        configurationUpdateHandler = { button in
            var config: UIButton.Configuration = button.configuration ?? .plain()
            if button.state == .selected {
                config.attributedTitle = .pretendard(.micro1_m_10, text: tab.title, color: .flintGray100)
                config.image = tab.icon.withTintColor(.flintGray50).resized(to: CGSize(width: 24, height: 24))
            } else {
                config.attributedTitle = .pretendard(.micro1_m_10, text: tab.title, color: .flintGray500)
                config.image = tab.icon.withTintColor(.flintGray500).resized(to: CGSize(width: 24, height: 24))
            }
            config.background.backgroundColor = .clear
            config.imagePadding = 0
            config.imagePlacement = .top
            config.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
            button.configuration = config
        }
    }
}
