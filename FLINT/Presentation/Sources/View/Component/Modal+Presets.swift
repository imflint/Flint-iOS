//
//  Modal+Presets.swift
//  FLINT
//
//  Created by 진소은 on 8/20/26.
//

import UIKit

public extension Modal {

    /// 저장한 작품 최소 개수 미달로 저장 취소가 불가능함을 안내하는 모달.
    /// - Parameter host: 모달을 띄울 상위 뷰 (보통 navigationController?.view ?? view)
    static func presentMinimumBookmarkLimit(in host: UIView) {
        var modalRef: Modal?
        let modal = Modal(
            image: DesignSystem.Icon.Gradient.bookmark,
            title: "작품 저장을 취소할 수 없어요",
            caption: "취향키워드 추출을 위해\n최소 5개 이상의 작품을 저장해주세요",
            leftButtonTitle: nil,
            rightButtonTitle: "확인",
            onRight: { _ in modalRef?.dismiss() }
        )
        modalRef = modal
        modal.show(in: host)
    }
}
