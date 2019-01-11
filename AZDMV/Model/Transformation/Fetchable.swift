//
//  Fetchable.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

import Foundation

enum Source {
    case bundled
    case online
    /// Only valid if `Self` is `Decodable`
    case cache(identifier: String)
}

protocol Fetchable {
    /// URL for `Source.bundled`
    static var localURL: URL? { get }
    /// URL for `Source.online`
    static var updateURL: URL { get }
    static func fetch(from source: Source) -> Self?
}

// MARK: - Default Implementations

extension Fetchable where Self: Persistent & Decodable {
    static func fetch(from source: Source) -> Self? {
        switch source {
        case .bundled:
            guard let url = localURL
                , let raw = try? String(contentsOf: url)
                , let data = raw.data(using: .utf8)
                else { return nil }
            return try! JSONDecoder().decode(self, from: data)
        case .online:
            guard let data = try? Data(contentsOf: updateURL)
                , let decoded = try? JSONDecoder().decode(self, from: data)
                else { return nil }
            return decoded
        case .cache(let id):
            return retrieve(withID: id)
        }
    }
}
