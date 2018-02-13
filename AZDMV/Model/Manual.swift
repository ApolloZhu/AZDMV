//
//  Manual.swift
//  AZDMV
//
//  Created by Apollo Zhu on 2/12/18.
//  Copyright © 2016-2018 DMV A-Z. MIT License.
//

import Foundation

struct Manual: Codable, Persistent { }

extension Manual: Fetchable {
    static let localURL = Bundle.main.url(forResource: "sections", withExtension: "json")
    static let updateURL: URL = "https://dmv-node-api-2.azurewebsites.net/api/manual/sections?manualID=1"
}
