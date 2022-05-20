//
//  APIService.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation
import Combine

public struct APIService {
    var manager: URLSession {
        return URLSession.shared
    }
    public init() {}
    internal func run<T: Decodable>(_ urlRequest: URLRequest) -> AnyPublisher<T,Error> {
        manager.dataTaskPublisher(for: urlRequest)
            .tryMap({ try handleURLResponse(output: $0, url: urlRequest.url!)})
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    internal func invalidRequest<T>() -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: NetworkingError.invalidRequest)
            .eraseToAnyPublisher()
    }
    private func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse
        else { throw NetworkingError.badURLResponse(url) }
        switch response.statusCode {
        case 200...299:
            return output.data
        case 400:
            throw NetworkingError.errorInputData
        case 401:
            throw NetworkingError.authError
        case 402...499:
            throw NetworkingError.badStatusCode(response.statusCode)
        case 500...599:
            throw NetworkingError.serverError
        default:
            throw NetworkingError.unknown
        }
    }
}

