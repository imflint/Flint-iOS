//
//  File.swift
//  Domain
//
//  Created by Hosung.Kim on 2026.08.25.
//

import Foundation

public struct SearchContentEntity {
    public let data: [ContentEntity]
    public let meta: MetaEntity
    
    public init(data: [ContentEntity], meta: MetaEntity) {
        self.data = data
        self.meta = meta
    }
}

extension SearchContentEntity {
    public struct MetaEntity {
        public let type: String?
        public let returned: Int?
        public let nextCursor: String?
        public let page: Int?
        public let size: Int?
        public let totalElements: String?
        public let totalPages: Int?
        
        public init(type: String?, returned: Int?, nextCursor: String?, page: Int?, size: Int?, totalElements: String?, totalPages: Int?) {
            self.type = type
            self.returned = returned
            self.nextCursor = nextCursor
            self.page = page
            self.size = size
            self.totalElements = totalElements
            self.totalPages = totalPages
        }
    }
}
