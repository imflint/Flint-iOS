//
//  NetworkEnvironment.swift
//  FLINT
//
//  Created by 진소은 on 1/10/26.
//

import Foundation

public enum NetworkEnvironment {
    private static var _config: NetworkConfig?

    public static var config: NetworkConfig {
        guard let config = _config else {
            fatalError("NetworkEnvironment is not configured. Call configure(_) at app start.")
        }
        return config
    }

    public static func configure(_ config: NetworkConfig) {
        _config = config
    }
}
