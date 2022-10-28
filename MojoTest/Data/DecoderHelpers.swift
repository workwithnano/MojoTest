//
//  DecoderHelpers.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

/// Since we're not getting clean JSON models, this helps us keep
/// our model structs clean while allowing us to parse arbitrary
/// dictionaries and arrays from the sample API results
extension Decodable {
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
    
    static func initMultiple(from: [Any]) throws -> [Self] {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let decodedArray = try decoder.decode([Self].self, from: data)
        return decodedArray
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let ISO8601WithFractionalSeconds = JSONDecoder.DateDecodingStrategy.custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
    }
}
