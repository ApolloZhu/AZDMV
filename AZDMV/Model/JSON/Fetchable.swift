//
//  Fetchable.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

enum Source {
    case cache(identifier: String)
    case url(URL)
}

protocol Fetchable {
    static func fetch(from source: Source) -> Self?
}

extension Fetchable where Self: Decodable {
    static func fetch(from source: Source) -> Self? {
        guard case .url(let url) = source
            , let data = try? Data(contentsOf: url)
            , let decoded = try? JSONDecoder().decode(self, from: data)
            else { return nil }
        return decoded
    }
}

extension Fetchable where Self: Decodable & Persistent {
    static func fetch(from source: Source) -> Self? {
        if let fromURL = fetch(from: source) { return fromURL }
        guard case .cache(let id) = source else { return nil }
        return retrieve(withID: id)
    }
}
