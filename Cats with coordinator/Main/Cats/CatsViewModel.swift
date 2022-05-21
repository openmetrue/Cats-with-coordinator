//
//  CatsViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import Foundation
import Combine

final class CatsMainViewModel: ObservableObject {
    
    @Published private(set) var state: CatsMainViewState = .loading
    @Published private(set) var cats: [Cat] = []
    @Published private(set) var breeds: [Breedes] = []
    @Published var searchText = ""
    
    private let limit = 40
    private var page = 0
    
    public let restOfCellsBeforeFetch = 10
    public let pullToRefreshSubject = PassthroughSubject<Void, Never>()
    public let loadMoreSubject = PassthroughSubject<Void, Never>()
    
    public let networkService: APIMethodService
    public let coreDataService: CoreDataMethodService
    
    init(networkService: APIMethodService, coreDataService: CoreDataMethodService) {
        self.networkService = networkService
        self.coreDataService = coreDataService
        setUpFetching()
    }
    
    private var bag = Set<AnyCancellable>()
    
    private func setUpFetching() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.isEmpty {
                    self.state = .all
                    return nil
                }
                self.state = .search
                return string
            })
            .compactMap { $0 }
            .sink(receiveValue: { [self] (searchText) in
                getCatsSearch(searchText)
            }).store(in: &bag)
    }
    public func refreshItems() {
        networkService.getAllCats(using: .init(page: page, limit: limit))
            .catch { error -> AnyPublisher<[Cat], Never> in
                let error = error as? LocalizedError
                self.state = .error(error ?? AppError.unknown)
                return .init(Just<[Cat]>([]))
            }
            .sink {
                self.cats = $0
                self.page = 0
            }
            .store(in: &bag)
    }
    public func getCatsSearch(_ searchText: String) {
        networkService.searchCats(using: .init(searchText))
            .catch { error -> AnyPublisher<[Breedes], Never> in
                let error = error as? LocalizedError
                self.state = .error(error ?? AppError.unknown)
                return .init(Just<[Breedes]>([]))
            }
            .sink {
                self.breeds = $0
                if $0.isEmpty {
                    self.state = .searchEmpty(searchText)
                }
            }
            .store(in: &bag)
    }
    public func fetchNextPageIfPossible() {
        networkService.getAllCats(using: .init(page: page, limit: limit))
            .catch { error -> AnyPublisher<[Cat], Never> in
                let error = error as? LocalizedError
                self.state = .error(error ?? AppError.unknown)
                return .init(Just<[Cat]>([]))
            }
            .sink {
                self.cats += $0
                self.page += 1
            }
            .store(in: &bag)
    }
    enum CatsMainViewState {
        case loading, search, searchEmpty(String), all, error(LocalizedError)
    }
}
