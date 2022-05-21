//
//  APIMethodService.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation
import Combine

protocol APIMethodService {
    func getAllCats(using model: APIRouter.GetAllCatsParameters) -> AnyPublisher<Response<[Cat]>, Error>
    func searchCats(using model: APIRouter.SearchCatsParameters) -> AnyPublisher<Response<[Breedes]>, Error>
    func getCatsFromID(using model: APIRouter.GetCatsFromIDParameters) -> AnyPublisher<Response<Cat>, Error>
}

extension APIService: APIMethodService {
    public func getAllCats(using model: APIRouter.GetAllCatsParameters) -> AnyPublisher<Response<[Cat]>, Error> {
        guard let request = APIRouter.getAllCats(model).asURLRequest else {
            return invalidRequest()
        }
        return run(request)
    }
    public func searchCats(using model: APIRouter.SearchCatsParameters) -> AnyPublisher<Response<[Breedes]>, Error> {
        guard let request = APIRouter.searchCats(model).asURLRequest else {
            return invalidRequest()
        }
        return run(request)
    }
    public func getCatsFromID(using model: APIRouter.GetCatsFromIDParameters) -> AnyPublisher<Response<Cat>, Error> {
        guard let request = APIRouter.getCatsFromID(model).asURLRequest else {
            return invalidRequest()
        }
        return run(request)
    }
}

