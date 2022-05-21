//
//  APIService.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation
import Combine

public struct Response<T> {
    let value: T
    let response: HTTPURLResponse
}

public struct APIService {
    var manager: URLSession {
        return URLSession.shared
    }
    public init() {}
    internal func run<T: Decodable>(_ urlRequest: URLRequest) -> AnyPublisher<Response<T>, Error> {
        manager.dataTaskPublisher(for: urlRequest)
            .tryMap({ try handleURLResponse(output: $0, url: urlRequest.url!)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    internal func invalidRequest<T>() -> AnyPublisher<Response<T>, Error> {
        Fail<Response<T>, Error>(error: NetworkingError.invalidRequest)
            .eraseToAnyPublisher()
    }
    private func handleURLResponse<T: Decodable>(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Response<T> {
        guard let response = output.response as? HTTPURLResponse
        else { throw NetworkingError.badURLResponse(url) }
        switch response.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            guard let value = try? decoder.decode(T.self, from: output.data)
            else { throw NetworkingError.errorOutputData }
            return Response(value: value, response: response)
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

