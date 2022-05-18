//
//  NetworkingError.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation

enum NetworkingError: LocalizedError {
    case badURLResponse(_ url: URL)
    case invalidRequest, errorInputData, authError, serverError, unknown
    case badStatusCode(_ statusCode: Int)
    var errorDescription: String {
        switch self {
        case .badURLResponse(let url):
            return "Bad response from URL: \(url)".localized
        case .invalidRequest:
            return "Request error".localized
        case .errorInputData:
            return "Input data error".localized
        case .authError:
            return "Authorization problem".localized
        case .badStatusCode(let statusCode):
            return "Bad status code returned: \(statusCode)".localized
        case .serverError:
            return "Server error".localized
        case .unknown:
            return "Unknown network error occured".localized
        }
    }
}
