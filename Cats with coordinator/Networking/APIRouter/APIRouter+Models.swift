//
//  APIRouter+Models.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation

extension APIRouter {
    public struct GetAllCatsParameters {
        public init(page: Int, limit: Int) {
            self.size = "small"
            self.mimeTypes = "jpg"
            self.limit = limit
            self.page = page
        }
        public let size: String
        public let mimeTypes: String
        public let limit: Int
        public let page: Int
        
        var queryItems: [URLQueryItem] {[
                buildQueryItem(name: "size", value: size),
                buildQueryItem(name: "mime_types", value: mimeTypes),
                buildQueryItem(name: "limit", value: "\(limit)"),
                buildQueryItem(name: "page", value: "\(page)")
            ]
            .compactMap { $0 }
        }
        func buildQueryItem(name: String, value: String?) -> URLQueryItem? {
            guard let value = value, value.isEmpty == false else { return nil }
            return URLQueryItem(name: name, value: value)
        }
    }
    
    public struct SearchCatsParameters {
        public init(_ query: String) {
            self.query = query
        }
        public let query: String
        var queryItems: [URLQueryItem] {[
            URLQueryItem(name: "q", value: query)
        ]}
    }
    
    public struct GetCatsFromIDParameters {
        public init(_ id: String) {
            self.id = id
        }
        public let id: String
    }
}

