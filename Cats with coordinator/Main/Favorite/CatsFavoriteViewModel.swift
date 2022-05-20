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
    private var bag = Set<AnyCancellable>()
    
    public func fetchCats() {
        let request = NSFetchRequest<CatDB>(entityName: "CatDB")
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatDB")
        CDAPI.publicher(delete: request)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { _ in
                self.fetchCats()
            }.store(in: &bag)
    }
    enum CatsFavoriteViewState {
        case empty, loading, loaded([CatDB]), error(Error)
    }
}
