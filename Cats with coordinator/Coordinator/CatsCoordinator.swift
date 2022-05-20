//
//  CatsCoordinator.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import SwiftUI
import Stinsen

final class CatsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \CatsCoordinator.start)
    @Root var start = makeCatsList
    @Route(.push) var catDetails = makeCatDetails
    @Route(.push) var breedDetails = makeBreedDetails
    
    @ObservedObject var viewModel: CatsMainViewModel
    
    init(viewModel: CatsMainViewModel) {
        self.viewModel = viewModel
    }
    
    @ViewBuilder func makeCatsList() -> some View {
        CatsMain(viewModel: viewModel)
    }
    @ViewBuilder func makeCatDetails(for cat: Cat) -> some View {
        CatsDetail(networkService: viewModel.networkService, cat: cat)
    }
    @ViewBuilder func makeBreedDetails(for breed: Breedes) -> some View {
        CatsDetail(networkService: viewModel.networkService, breed: breed)
    }
}
