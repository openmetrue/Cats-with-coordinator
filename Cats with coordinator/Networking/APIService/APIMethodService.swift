//
//  APIMethodService.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation
import Combine

protocol APIMethodService {
    func getAllCats(using model: APIRouter.GetAllCatsParameters) -> AnyPublisher<[Cat], Error>
    func searchCats(using model: APIRouter.SearchCatsParameters) -> AnyPublisher<[Breedes], Error>
    func getCatsFromID(using model: APIRouter.GetCatsFromIDParameters) -> AnyPublisher<Cat, Error>
}

extension APIService: APIMethodService {
    public func getAllCats(using model: APIRouter.GetAllCatsParameters) -> AnyPublisher<[Cat], Error> {
        guard let request = APIRouter.getAllCats(model).asURLRequest else {
            return invalidRequest()
        }
        return run(request)
    }
    public func searchCats(using model: APIRouter.SearchCatsParameters) -> AnyPublisher<[Breedes], Error> {
        guard let request = APIRouter.searchCats(model).asURLRequest else {
            return invalidRequest()
        }
        return run(request)
    }
    public func getCatsFromID(using model: APIRouter.GetCatsFromIDParameters) -> AnyPublisher<Cat, Error> {
        guard let request = APIRouter.getCatsFromID(model).asURLRequest else {
            return invalidRequest()
        }
        return run(request)
    }
}

