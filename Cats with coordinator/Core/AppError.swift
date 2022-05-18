//
//  AppError.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation

public enum AppError: LocalizedError {
    case unknown
    public var errorDescription: String? {
        switch self {
        case .unknown: return "Unknown app error".localized
        }
    }
}
