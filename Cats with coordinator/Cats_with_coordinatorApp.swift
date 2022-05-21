//
//  Cats_with_coordinatorApp.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import SwiftUI
import Stinsen

@main
struct Cats_with_coordinatorApp: App {
    
    let catsMainViewModel: CatsMainViewModel
    let catsFavoriteViewModel: CatsFavoriteViewModel
    
    let networkService: APIMethodService
    let coreDataService: CoreDataMethodService
    
    init() {
        self.networkService = APIService()
        self.coreDataService = CoreDataService(name: "Model")
        
        self.catsMainViewModel = CatsMainViewModel(networkService: networkService, coreDataService: coreDataService)
        self.catsFavoriteViewModel = CatsFavoriteViewModel(coreDataService: coreDataService)
    }
    var body: some Scene {
        WindowGroup {
            TabCoordinator(catsMainViewModel: catsMainViewModel,
                           catsFavoriteViewModel: catsFavoriteViewModel).view()
        }
    }
}
