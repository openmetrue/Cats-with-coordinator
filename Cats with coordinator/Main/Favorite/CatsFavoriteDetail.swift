//
//  CatsFavoriteDetail.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI

struct CatsFavoriteDetail: View {
    
    public let cat: CatDB
    
    var body: some View {
        VStack {
            if let imageData = cat.image,
               let uiimage = UIImage(data: imageData),
               let image = Image(uiImage: uiimage) {
                image.centerCropped()
            }
            List {
                Text("Cat's ID: \(cat.id!)")
                Text("Photo: \(cat.width)x\(cat.height)")
                if let categories = cat.categoryDB,
                   categories != [] {
                    Section(header: Text("Category")) {
                        ForEach(Array(categories as? Set<CategoryDB> ?? [])) { category in
                            Text(category.name!)
                        }
                    }
                }
                if let breeds = cat.breedDB,
                   breeds != [] {
                    Section(header: Text("Breed")) {
                        ForEach(Array(breeds as? Set<BreedDB> ?? [])) { breed in
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
    }
}

