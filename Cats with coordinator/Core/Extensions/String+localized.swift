//
//  String+localized.swift
//  Cats with coordinator
//
//  Created by Mark Khmelnitskii on 18.05.2022.
//

import Foundation

extension String {
    public var localized: String {
        NSLocalizedString(self, bundle: Bundle(for: BundleClass.self), comment: "")
    }
}
private class BundleClass {}
