//
//  CatsMain.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI

struct CatsMain: View {
    
    @EnvironmentObject var router: CatsCoordinator.Router
    
    @ObservedObject var viewModel: CatsMainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $viewModel.searchText)
            Group {
                switch viewModel.state {
                case .loading:
                    Spacer()
                    ProgressView()
                        .onAppear(perform: viewModel.fetchNextPageIfPossible)
                    Spacer()
                case .search:
                    List(viewModel.breeds, id: \.id) { breed in
                        Button {
                            router.route(to: \.breedDetails, breed)
                        } label: {
                            Text("\(breed.name), from: \(breed.countryCode ?? "")")
                        }
                    }.id(UUID())
                case .searchEmpty(let search):
                    List {
                        Text("No results found for \(search)".localized)
                    }.listStyle(.inset)
                case .all:
                    UIKitCollection(items: viewModel.cats, prefetchLimit: viewModel.restOfCellsBeforeFetch, loadMoreSubject: viewModel.loadMoreSubject, pullToRefreshSubject: viewModel.pullToRefreshSubject) { indexPath, item in
                        Button {
                            router.route(to: \.catDetails, item)
                        } label: {
                            CatsCell(item: item, index: indexPath.row)
                        }
                    }
                    .onReceive(viewModel.loadMoreSubject) {
                        self.viewModel.fetchNextPageIfPossible()
                    }
                    .onReceive(viewModel.pullToRefreshSubject) {
                        self.viewModel.refreshItems()
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                case .error(let error):
                    Spacer()
                    Text(error.localizedDescription)
                    Spacer()
                }
            }
        }
        .environment(\.disableAutocorrection, true)
        .navigationBarTitle("Сat's observer", displayMode: .inline)
    }
}
