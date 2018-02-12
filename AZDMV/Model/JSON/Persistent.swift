//
//  Persistent.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

protocol Persistent {
    @discardableResult
    func persist(withID identifier: String) -> Bool
    static func retrieve(withID identifier: String) -> Self?
}

extension Persistent {
    static func url(forID identifier: String) -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(identifier)
    }
}

extension Persistent where Self: Encodable {
    @discardableResult
    func persist(withID identifier: String) -> Bool {
        guard let encoded = try? JSONEncoder().encode(self)
            , let url = Self.url(forID: identifier)
            , let _ = try? encoded.write(to: url)
            else { return false }
        return true
    }
}

extension Persistent where Self: Decodable {
    static func retrieve(withID identifier: String) -> Self? {
        guard let url = Self.url(forID: identifier)
            , let data = try? Data(contentsOf: url)
            , let decoded = try? JSONDecoder().decode(self, from: data)
            else { return nil }
        return decoded
    }
}