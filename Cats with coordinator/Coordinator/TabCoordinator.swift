//
//  TabCoordinator.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import SwiftUI
import Stinsen

final class TabCoordinator: TabCoordinatable {
    
    lazy var child = TabChild(startingItems: [
        \TabCoordinator.cats,
         \TabCoordinator.favorite
    ])
    
    @Route(tabItem: makeCatsTab) var cats = makeCats
    @Route(tabItem: makeFavoriteTab) var favorite = makeFavorite
    
    let catsCoordinator: CatsCoordinator
    let favoriteCoordinator: FavoriteCoordinator
    
    init(catsMainViewModel: CatsMainViewModel, catsFavoriteViewModel: CatsFavoriteViewModel) {
        self.catsCoordinator = CatsCoordinator(viewModel: catsMainViewModel)
        self.favoriteCoordinator = FavoriteCoordinator(viewModel: catsFavoriteViewModel)
    }
    
    func makeCats() -> NavigationViewCoordinator<CatsCoordinator> {
        NavigationViewCoordinator(catsCoordinator)
    }
    
    func makeFavorite() -> NavigationViewCoordinator<FavoriteCoordinator> {
        NavigationViewCoordinator(favoriteCoordinator)
    }
    
    @ViewBuilder func makeCatsTab(isActive: Bool) -> some View {
        VStack {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
        .foregroundColor(isActive ? .blue : .black)
    }
    
    @ViewBuilder func makeFavoriteTab(isActive: Bool) -> some View {
        VStack {
            Image(systemName: "heart")
            Text("My offline cats")
        }
        .foregroundColor(isActive ? .blue : .black)
    }
}

