//
//  Position.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

struct Position {
    let id = UUID()
    let shareQuantity: Double // TODO: Increase precision, use Ints
    let totalGainDollarsFormatted: String?
    let totalGainPercentageFormatted: String?
    let type: PositionType
    /// > Note: This is mutatable due to the need to shoehorn in
    /// the price history from a hanging object in the flat JSON
    var stock: Stock
}

enum PositionType: String, Codable, CaseIterable, Identifiable {
    case long = "LONG"
    case short = "SHORT"
    
    var id: String {
        return self.rawValue
    }
}

enum PositionFormat: String {
    case dollars = "Total Return $"
    case percentage = "Total Return %"
}

extension Position: Identifiable {
    // TODO: Custom identification code. We don't currently have IDs given to us by back-end
}

extension Position: Decodable {
    enum CodingKeys: String, CodingKey {
        case shareQuantity
        case totalGainDollarsFormatted
        case totalGainPercentageFormatted
        case type
        case stock
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shareQuantity = try container.decode(Double.self, forKey: .shareQuantity)
        totalGainDollarsFormatted = try container.decodeIfPresent(String.self, forKey: .totalGainDollarsFormatted)
        totalGainPercentageFormatted = try container.decodeIfPresent(String.self, forKey: .totalGainPercentageFormatted)
        type =  try container.decode(PositionType.self, forKey: .type)
        stock = try container.decode(Stock.self, forKey: .stock)
    }
}

/// In order to handle grouping in SwiftUI, it helps to have an actual struct/class
/// that can conform to `Identifiable` for placement in lists. Otherwise this
/// could have been a typealias
struct PositionGroup {
    let type: PositionType
    var positions: [Position]
}

extension PositionGroup: Identifiable {
    var id: PositionType {
        return type
    }
    
    
}
