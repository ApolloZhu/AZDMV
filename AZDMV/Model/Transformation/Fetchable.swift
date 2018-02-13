//
//  Fetchable.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

enum Source {
    case bundled
    case online
    /// Only valid if `Self` is `Decodable`
    case cache(identifier: String)
}

protocol Fetchable {
    static func fetch(from source: Source) -> Self?
    /// URL for `Source.bundled`
    static var localURL: URL? { get }
    /// URL for `Source.online`
    static var updateURL: URL { get }
}

// MARK: - Default Implementations

extension Fetchable where Self: Decodable {
    static func fetch(from source: Source) -> Self? {
        let url: URL?
        switch source {
        case .bundled: url = localURL
        case .online: url = updateURL
        default: return nil
        }
        guard let dataURL = url
            , let data = try? Data(contentsOf: dataURL)
            , let decoded = try? JSONDecoder().decode(self, from: data)
            else { return nil }
        return decoded
    }
}

extension Fetchable where Self: Persistent {
    static func fetch(from source: Source) -> Self? {
        guard case .cache(let id) = source
            else { return fetch(from: source) }
        return retrieve(withID: id)
    }
}

extension Fetchable where Self: Persistent & Decodable {
    static func fetch(from source: Source) -> Self? {
        // #warning FIXME: Check what this does...
        return fetch(from: source)
    }
}
