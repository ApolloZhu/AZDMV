//
//  OptionalCodable.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/13/18.
//  Copyright © 2016-2019 DMV A-Z. MIT License.
//

struct OptionalCodable<Wrapped: Codable>: Codable {
    let some: Wrapped?
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        some = try? container.decode(Wrapped.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(some)
    }
}
