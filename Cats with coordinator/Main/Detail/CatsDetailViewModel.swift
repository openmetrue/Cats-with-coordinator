//
//  CatsDetailViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import Foundation
import Combine
import SwiftUI

final class CatsDetailViewModel: ObservableObject {
    
    @Published private(set) var state: CatsDetailViewState = .loading
    @Published private(set) var saved: Bool = false
    
    let networkService: APIMethodService
    let coreDataService: CoreDataService
    
    public init(networkService: APIMethodService, coreDataService: CoreDataService, cat: Cat) {
        self.networkService = networkService
        self.coreDataService = coreDataService
        self.state = .loaded(cat)
    }
    
    public init(networkService: APIMethodService, coreDataService: CoreDataService, breed: Breedes) {
        self.networkService = networkService
        self.coreDataService = coreDataService
        loadCat(id: breed.referenceImageID ?? "hBXicehMA")
    }
    
    private var bag = Set<AnyCancellable>()
    
    public func loadCat(id: String) {
        networkService.getCatsFromID(using: .init(id))
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            }, receiveValue: {
                self.state = .loaded($0)
            }).store(in: &bag)
    }
    
    public func save(_ cat: Cat) {
        saved = true
        let action: (() -> Void) = {
            let catDB: CatDB = self.coreDataService.createEntity()
            catDB.unicID = UUID()
            catDB.id = cat.id
            catDB.url = cat.url
            catDB.width = Int64(cat.width)
            catDB.height = Int64(cat.height)
            catDB.image = try? Data(contentsOf: URL(string: cat.url)!)
            var breedsDB: [BreedDB] = []
            for breed in cat.breeds {
                let breedDB: BreedDB = self.coreDataService.createEntity()
                breedDB.id = breed.id
                breedDB.name = breed.name
                breedDB.breedDescription = breed.breedDescription
                breedsDB.append(breedDB)
            }
            var categoriesDB: [CategoryDB] = []
            if let categories = cat.categories {
                for category in categories {
                    let categoryDB: CategoryDB = self.coreDataService.createEntity()
                    categoryDB.id = Int64(category.id)
                    categoryDB.name = category.name
                    categoriesDB.append(categoryDB)
                }
            }
            catDB.breedDB = NSSet(array: breedsDB)
            catDB.categoryDB = NSSet(array: categoriesDB)
        }
        
        coreDataService.publicher(save: action)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: {
                switch $0 {
                case true:
                    DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("SuccessSaved"), object: nil)
                    }
                case false:
                    print("DB error")
                }
            }.store(in: &bag)
    }
    
    enum CatsDetailViewState {
        case loading, loaded(Cat), error(Error)
    }
}

