//
//  CatsCollection.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI
import Combine

struct UIKitCollection<Item: Hashable, Cell: View>: UIViewControllerRepresentable {
    
    private var items: [Item]
    private let prefetchLimit: Int?
    private let cell: (IndexPath, Item) -> Cell
    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    private let pullToRefreshSubject: PassthroughSubject<Void, Never>?
    
    public init(items: [Item], prefetchLimit: Int? = nil, loadMoreSubject: PassthroughSubject<Void, Never>? = nil, pullToRefreshSubject: PassthroughSubject<Void, Never>? = nil, @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell) {
        self.items = items
        self.prefetchLimit = prefetchLimit
        self.loadMoreSubject = loadMoreSubject
        self.pullToRefreshSubject = pullToRefreshSubject
        self.cell = cell
    }

    func makeUIViewController(context _: Context) -> CollectionViewController<Item, Cell> {
        CollectionViewController(prefetchLimit: prefetchLimit, loadMoreSubject: loadMoreSubject, pullToRefreshSubject: pullToRefreshSubject, cell: cell)
    }

    func updateUIViewController(_ view: CollectionViewController<Item, Cell>, context _: Context) {
        view.updateSnapshot(items: items)
    }
}
