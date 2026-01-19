//
//  ProfileViewController.swift
//  FLINT
//
//  Created by 진소은 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class ProfileViewController: UIViewController {

    private enum Row {
        case profileHeader
        case titleHeader(style: TitleHeaderTableViewCell.HeaderStyle,
                         title: String,
                         subtitle: String)
        case preferenceChips(keywords: [KeywordDTO])
        case collection(items: [MoreNoMoreCollectionItem])
        case recentSaved(items: [RecentSavedContentItem])
    }

    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .flintBackground
    }

    private let dummyData: [KeywordDTO] = [
        .init(color: .blue,   rank: 1, name: "영화",   percentage: 0, imageUrl: "https://d2z8tag0uwa5d5.cloudfront.net/keywords/logo/260119/1c5281f4-6101-401c-9a19-ff5cbe8d6313.png"),
        .init(color: .pink,   rank: 2, name: "애니메이션",     percentage: 0, imageUrl: "https://d2z8tag0uwa5d5.cloudfront.net/keywords/logo/260119/e8c333c9-f7cd-4537-b25e-8ec7b53598a2.png"),
        .init(color: .green,  rank: 3, name: "영화", percentage: 0, imageUrl: "https://picsum.photos/seed/3/80"),
        .init(color: .orange, rank: 4, name: "공포",   percentage: 0, imageUrl: "https://picsum.photos/seed/4/80"),
        .init(color: .yellow, rank: 5, name: "액션",   percentage: 0, imageUrl: "https://picsum.photos/seed/5/80"),
        .init(color: .pink,   rank: 6, name: "성장",   percentage: 0, imageUrl: "https://picsum.photos/seed/6/80"),
    ]
    
    private let moreNoMoreDummy: [MoreNoMoreCollectionItem] = [
        MoreNoMoreCollectionItem(
            id: UUID(),
            image: UIImage(resource: .imgCollectionBg),
            profileImage: UIImage(resource: .imgProfileGray),
            title: "요즘 많이 보는 콘텐츠",
            userName: "쏘나기"
        ),
        MoreNoMoreCollectionItem(
            id: UUID(),
            image: UIImage(resource: .imgCollectionBg),
            profileImage: UIImage(resource: .imgProfileGray),
            title: "취향 저격 영화 모음",
            userName: "플린트"
        ),
        MoreNoMoreCollectionItem(
            id: UUID(),
            image: UIImage(resource: .imgCollectionBg),
            profileImage: UIImage(resource: .imgProfileGray),
            title: "혼자 보기 좋은 작품",
            userName: "영화광"
        )
    ]
    
    private let recentSavedDummy: [RecentSavedContentItem] = [
        RecentSavedContentItem(
            posterImageName: "img_collection_bg",
            title: "인터스텔라",
            year: 2014,
            availableOn: [.netflix, .watcha],
            subscribedOn: [.netflix, .tving]
        ),
        RecentSavedContentItem(
            posterImageName: "img_collection_bg",
            title: "라라랜드",
            year: 2016,
            availableOn: [.watcha, .disneyPlus],
            subscribedOn: [.watcha, .disneyPlus]
        ),
        RecentSavedContentItem(
            posterImageName: "img_collection_bg",
            title: "듄",
            year: 2021,
            availableOn: [.tving, .disneyPlus],
            subscribedOn: [.tving]
        ),
        RecentSavedContentItem(
            posterImageName: "img_collection_bg",
            title: "기생충",
            year: 2019,
            availableOn: [.netflix],
            subscribedOn: [.netflix, .watcha]
        )
    ]


    private lazy var rows: [Row] = [
        .profileHeader,
        .titleHeader(style: .normal, title: "쏘나기님의 취향 키워드", subtitle: "쏘나기님이 관심있어하는 키워드예요"),
        .preferenceChips(keywords: dummyData),
        .titleHeader(style: .more, title: "쏘나기님의 컬렉션", subtitle: "쏘나기님이 생성한 컬렉션이에요"),
        .collection(items: moreNoMoreDummy),
        .titleHeader(style: .more, title: "저장한 컬렉션", subtitle: "쏘나기님이 저장한 컬렉션이에요"),
        .collection(items: moreNoMoreDummy),
        .titleHeader(style: .more, title: "저장한 작품", subtitle: "쏘나기님이 저장한 작품이에요"),
        .recentSaved(items: recentSavedDummy)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = .flintBackground

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            ProfileHeaderTableViewCell.self,
            forCellReuseIdentifier: ProfileHeaderTableViewCell.reuseIdentifier
        )

        tableView.register(
            TitleHeaderTableViewCell.self,
            forCellReuseIdentifier: TitleHeaderTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            PreferenceRankedChipTableViewCell.self, forCellReuseIdentifier: PreferenceRankedChipTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            MoreNoMoreCollectionTableViewCell.self, forCellReuseIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            RecentSavedContentTableViewCell.self, forCellReuseIdentifier: RecentSavedContentTableViewCell.reuseIdentifier
        )
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch rows[indexPath.section] {
        case .profileHeader:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? ProfileHeaderTableViewCell else {
                return UITableViewCell()
            }

            cell.selectionStyle = .none
            cell.configure(name: "쏘나기", isVerified: true)

            return cell

        case let .titleHeader(style, title, subtitle):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleHeaderTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? TitleHeaderTableViewCell else {
                return UITableViewCell()
            }

            cell.configure(style: style, title: title, subtitle: subtitle)

            cell.onTapMore = { [weak self] in
                guard let self else { return }
                self.didTapMore(for: indexPath)
            }

            return cell
            
        case let .preferenceChips(keywords):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PreferenceRankedChipTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? PreferenceRankedChipTableViewCell else { return UITableViewCell() }

            cell.configure(keywords: keywords)
            return cell
        case let .collection(items):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MoreNoMoreCollectionTableViewCell

            cell.configure(items: items)

            cell.onSelectItem = { item in
                print(item.title, item.userName)
            }

            return cell

        case let .recentSaved(items):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RecentSavedContentTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! RecentSavedContentTableViewCell

            cell.configure(items: items)

            cell.onTapItem = { item in
                Log.d("최근 저장 작품 탭:", item)
            }

            return cell

        }
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch rows[section] {
            
        case .profileHeader:
            return 6
        case .titleHeader:
            return 0
        case .preferenceChips:
            return 48
        case .collection:
            return 24
        case .recentSaved:
            return 24
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.section] {
        case .profileHeader:
            break
        case .titleHeader:
            break
        case .preferenceChips:
            break
        case .collection:
            break
        case .recentSaved:
            break
        }
    }
}

// MARK: - Actions

private extension ProfileViewController {

    func didTapMore(for indexPath: IndexPath) {
        switch rows[indexPath.section] {
        case .titleHeader:
            print("More tapped at row \(indexPath.row)")
        default:
            break
        }
    }
}
