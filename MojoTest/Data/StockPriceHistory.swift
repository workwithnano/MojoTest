//
//  StockPriceHistory.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import Foundation

struct StockPriceHistory {
    
    /// Identifer to conform to `Identifiable`
    var id = UUID()
    
    let formattedPercentageChange: String
    let formattedPriceChange: String
    let historicalPrices: [HistoricalPrice]
    
}

extension StockPriceHistory: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case formattedPercentageChange
        case formattedPriceChange
        case priceHistory
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        formattedPercentageChange = try container.decode(String.self, forKey: .formattedPercentageChange)
        formattedPriceChange = try container.decode(String.self, forKey: .formattedPriceChange)
        historicalPrices = try container.decode([HistoricalPrice].self, forKey: .priceHistory)
        
    }
}

extension StockPriceHistory: Identifiable, Hashable {
    
}

/// Leaving this in `internal` scope so the rest of the app can
/// access it
struct HistoricalPrice: Decodable, Hashable {
    let midFormatted: String
    let mid: Double // TODO: improve precision by converting to Int
    let isLowPrice: Bool
    let isHighPrice: Bool
    let createdAt: Date
}
