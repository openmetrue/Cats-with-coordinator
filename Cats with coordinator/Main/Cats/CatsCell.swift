//
//  CatsMainCell.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI

struct CatsCell: View {
    
    public var item: Cat
    public var index: Int
    
    var body: some View {
        AsyncImageCached(url: item.url) { image in
            image.centerCropped()
        } placeholder: {
            ProgressView()
        }
    }
}


