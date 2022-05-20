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
    
    let networkService: APIService
    
    init() {
        self.networkService = APIService()
        self.catsMainViewModel = CatsMainViewModel(networkService: networkService)
        self.catsFavoriteViewModel = CatsFavoriteViewModel()
    }
    var body: some Scene {
        WindowGroup {
            TabCoordinator(catsMainViewModel: catsMainViewModel,
                           catsFavoriteViewModel: catsFavoriteViewModel).view()
        }
    }
}
