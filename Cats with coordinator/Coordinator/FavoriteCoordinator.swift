//
//  FavoriteCoordinator.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import SwiftUI
import Stinsen

final class FavoriteCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \FavoriteCoordinator.start)
    @Root var start = makeFavoriteList
    @Route(.push) var catFavoriteDetails = makeFavoriteDetails
    
    @ObservedObject var viewModel: CatsFavoriteViewModel
    
    init(viewModel: CatsFavoriteViewModel) {
        self.viewModel = viewModel
    }
    
    @ViewBuilder func makeFavoriteList() -> some View {
        CatsFavorite(viewModel: viewModel)
    }
    @ViewBuilder func makeFavoriteDetails(for cat: CatDB) -> some View {
        CatsFavoriteDetail(cat: cat)
    }
}
