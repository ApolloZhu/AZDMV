//
//  Persistent.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
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

// MARK: - Default Implementations

extension Array: Persistent where Element: Codable { }

extension Persistent where Self: Codable {
    @discardableResult
    func persist(withID identifier: String) -> Bool {
        guard let encoded = try? JSONEncoder().encode(self)
            , let url = Self.url(forID: identifier)
            , let _ = try? encoded.write(to: url)
            else { return false }
        return true
    }
    
    static func retrieve(withID identifier: String) -> Self? {
        guard let url = Self.url(forID: identifier)
            , let data = try? Data(contentsOf: url)
            , let decoded = try? JSONDecoder().decode(self, from: data)
            else { return nil }
        return decoded
    }
}
