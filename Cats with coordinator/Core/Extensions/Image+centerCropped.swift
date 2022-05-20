//
//  Image+centerCropped.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 20.05.2022.
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        Color.clear
        .overlay(
            self
            .resizable()
            .scaledToFill()
        )
        .clipped()
    }
}
