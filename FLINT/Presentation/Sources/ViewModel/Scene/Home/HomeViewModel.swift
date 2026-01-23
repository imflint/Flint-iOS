//
//  HomeViewModel.swift
//  Presentation
//
//  Created by 소은 on 2026.01.23.
//

import Foundation
import Combine

import Domain
import Entity

public final class HomeViewModel {

    // MARK: - Section / Row

    public struct SectionModel {
        public let rows: [Row]
    }

    public enum TitleHeaderStyle {
        case normal
        case more
    }

    public enum Row {
        case greeting(userName: String)
        case header(style: TitleHeaderStyle, title: String, subtitle: String)
        case fliner(items: [CollectionEntity])

        // TODO: 최근 저장 콘텐츠/눈여겨보는 컬렉션도 동일 패턴으로 확장
        case ctaButton(title: String)
    }

    // MARK: - Output

    @Published public private(set) var sections: [SectionModel] = []

    // MARK: - Dependencies

    private let homeUseCase: HomeUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State

    private var userName: String
    private var flinerCollections: [CollectionEntity] = []

    // MARK: - Init

    public init(
        homeUseCase: HomeUseCase,
        initialUserName: String = "얀비"
    ) {
        self.homeUseCase = homeUseCase
        self.userName = initialUserName
        self.sections = makeSections()
    }

    // MARK: - Input

    public func load() {
        homeUseCase.fetchRecommendedCollections()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ fetchRecommendedCollections failed:", error)
                }
            } receiveValue: { [weak self] items in
                guard let self else { return }

                self.flinerCollections = items.map { info in
                    CollectionEntity(
                        id: "",
                        thumbnailUrl: info.imageUrlString,
                        title: info.title,
                        description: "",
                        imageList: [],
                        bookmarkCount: 0,
                        isBookmarked: false,
                        userId: "",
                        nickname: info.userName,
                        profileImageUrl: info.profileImageUrlString
                    )
                }

                self.sections = self.makeSections()
            }
            .store(in: &cancellables)
    }

    // MARK: - Builder

    private func makeSections() -> [SectionModel] {
        var result: [SectionModel] = []

        // 1) Greeting
        result.append(
            .init(rows: [
                .greeting(userName: userName)
            ])
        )

        // 2) Fliner 추천 컬렉션
        var flinerRows: [Row] = [
            .header(
                style: .normal,
                title: "Fliner의 추천 컬렉션을 만나보세요",
                subtitle: "Fliner는 콘텐츠에 진심인, 플린트의 큐레이터들이에요"
            )
        ]

        if !flinerCollections.isEmpty {
            flinerRows.append(.fliner(items: flinerCollections))
        }

        result.append(.init(rows: flinerRows))

        // 3) 최근 저장한 콘텐츠 (지금은 헤더만 유지)
        result.append(
            .init(rows: [
                .header(
                    style: .normal,
                    title: "최근 저장한 콘텐츠",
                    subtitle: "현재 구독 중인 OTT에서 볼 수 있는 작품들이에요"
                )
            ])
        )

        // 4) 눈여겨보고 있는 컬렉션 (지금은 헤더만 유지)
        result.append(
            .init(rows: [
                .header(
                    style: .more,
                    title: "눈여겨보고 있는 컬렉션",
                    subtitle: "\(userName)님이 최근 살펴본 컬렉션이에요"
                )
            ])
        )

        return result
    }
}
