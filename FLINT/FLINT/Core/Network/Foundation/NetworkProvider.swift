//
//  NetworkProvider.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

import Moya

public enum NetworkProvider {
    public static func make<API: TargetType>() -> MoyaProvider<API> {
        // 필요한 plugin(로그/인증 등)은 여기서 추가
        let plugins: [PluginType] = []
        return MoyaProvider<API>(plugins: plugins)
    }
}
