//
//  Cats.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import Foundation

public struct Cat: Codable, Equatable {
    var uuid = UUID()
    let breeds: [Breed]?
    let categories: [Category]?
    let id: String
    let url: String
    let width, height: Int
    
    enum CodingKeys: String, CodingKey {
        case breeds, categories
        case id, url, width, height
    }
}

extension Cat: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: Cat, rhs: Cat) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

public struct Breed: Codable, Equatable, Hashable {
    let id, name: String?
    let breedDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case breedDescription = "description"
    }
}

public struct Category: Codable, Equatable, Hashable {
    let id: Int
    let name: String
}
