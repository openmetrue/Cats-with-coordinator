//
//  ImageCache.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/19/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import UIKit

protocol ImageCache {
    subscript(_ url: URL) -> Data? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache: LRUCache<NSURL, Data> = {
        let cache = LRUCache<NSURL, Data>()
        cache.countLimit = 100 // items limit
        cache.totalCostLimit = 1024 * 1024 * 256 // memory limit
        return cache
    }()
    
    subscript(_ key: URL) -> Data? {
        get { cache.value(forKey: key as NSURL) }
        set { cache.setValue(newValue!, forKey: key as NSURL) }
    }
}
