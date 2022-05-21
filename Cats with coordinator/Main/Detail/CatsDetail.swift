//
//  CatsDetail.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI

struct CatsDetail: View {
    
    @ObservedObject var viewModel: CatsDetailViewModel
    
    public init(networkService: APIMethodService, coreDataService: CoreDataService, breed: Breedes) {
        self.viewModel = CatsDetailViewModel(networkService: networkService, coreDataService: coreDataService, breed: breed)
    }
    
    public init(networkService: APIMethodService, coreDataService: CoreDataService, cat: Cat) {
        self.viewModel = CatsDetailViewModel(networkService: networkService, coreDataService: coreDataService, cat: cat)
    }
    
    var body: some View {
        switch viewModel.state {
        case .loaded(let cat):
            Group {
                VStack {
                    AsyncImageCached(url: cat.url) { image in
                        image.centerCropped()
                    } placeholder: {
                        ProgressView()
                    }
                    List {
                        Text("Cat's ID: \(cat.id)")
                        Text("Photo: \(cat.width)x\(cat.height)")
                        if let categories = cat.categories {
                            Section(header: Text("Category")) {
                                ForEach(categories, id: \.id) { category in
                                    Text(category.name)
                                }
                            }
                        }
                        if let breeds = cat.breeds,
                           breeds != [] {
                            Section(header: Text("Breed")) {
                                ForEach(breeds, id: \.id) { breed in
                                    if let name = breed.name {
                                        Text("\(name)")
                                    }
                                    if let breedDescription = breed.breedDescription {
                                        Text("\(breedDescription)")
                                    }
                                }
                            }
                        }
                    } .id(UUID())
                }
            } .toolbar {
                Button {
                    viewModel.save(cat)
                } label: {
                    Text("Save to offline")
                }
                .foregroundColor(viewModel.saved ? Color.secondary : Color.accentColor)
                .disabled(viewModel.saved)
            }
        case .loading:
            ProgressView()
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
}
