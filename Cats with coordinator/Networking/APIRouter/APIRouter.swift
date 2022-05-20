//
//  APIRouter.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation

public enum APIRouter {
    case getAllCats(GetAllCatsParameters)
    case searchCats(SearchCatsParameters)
    case getCatsFromID(GetCatsFromIDParameters)
}

extension APIRouter {
    private static let baseURLComponents: URLComponents? = {
        #if DEBUG
        return URLComponents(string: "https://api.thecatapi.com") // Development server baseURL
        #else
        return URLComponents(string: "https://api.thecatapi.com") // Production server baseURL
        #endif
    }()
    private var method: HTTPMethod {
        switch self {
        case .getAllCats: return .GET
        case .searchCats: return .GET
        case .getCatsFromID: return .GET
        }
    }
    private var path: String {
        var path = "/v1/"
        switch self {
        case .getAllCats: path.append("images/search")
        case .searchCats: path.append("breeds/search")
        case .getCatsFromID: path.append("images/")
        }
        return path
    }
    var asURLRequest: URLRequest? {
        guard var urlComponents = APIRouter.baseURLComponents else {
            assertionFailure()
            return nil
        }
        urlComponents.path = path
        switch self {
        case .getAllCats(let model):
            urlComponents.queryItems = model.queryItems
        case .searchCats(let model):
            urlComponents.queryItems = model.queryItems
        case .getCatsFromID(let model):
            urlComponents.path.append(model.id)
        }
        guard let url = urlComponents.url else {
            assertionFailure()
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

