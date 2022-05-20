//
//  SearchField.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 21.04.2022.
//

import SwiftUI

struct SearchField: View {
    
    @Binding var text: String
    @State private var isButtonShown = false
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    TextField("Search...", text: $text) { (editingChanged) in
                        isButtonShown = editingChanged
                    }
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
                    if !text.isEmpty {
                        Button(action: {text.removeAll()}){
                            Image(systemName: "xmark.circle.fill")
                        }
                        .padding(.trailing, 8)
                        .foregroundColor(.gray)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
                if isButtonShown {
                    Button(action: {buttonClicked()}) {
                        Text("Cancel")
                    }
                    .padding(.leading, 8)
                    .buttonStyle(.plain)
                }
            }
        }
        .animation(.default, value: isButtonShown)
        .multilineTextAlignment(.leading)
        .padding()
    }
    
    private func buttonClicked() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isButtonShown = false
    }
}
