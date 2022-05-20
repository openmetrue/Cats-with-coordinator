//
//  CatsFavoriteViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI
import CoreData
import Combine

final class CatsFavoriteViewModel: ObservableObject {
    @Published private(set) var state: CatsFavoriteViewState = .loading
    private let request = NSFetchRequest<CatDB>(entityName: "CatDB")
    private let requestDelete = NSFetchRequest<NSFetchRequestResult>(entityName: "CatDB")
    private var bag = Set<AnyCancellable>()
    
    init() {
        fetchCats()
    }
    
    public func fetchCats() {
        CDAPI.publicher(fetch: request)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    if error.code == 0 {
                        self.state = .empty
                    } else {
                        self.state = .error(error)
                    }
                }
            } receiveValue: {
                if $0.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .loaded($0)
                }
            }.store(in: &bag)
    }
    
    public func deleteAll() {
        CDAPI.publicher(delete: requestDelete)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { _ in
                self.state = .empty
            }.store(in: &bag)
    }
    enum CatsFavoriteViewState {
        case empty, loading, loaded([CatDB]), error(Error)
    }
}
