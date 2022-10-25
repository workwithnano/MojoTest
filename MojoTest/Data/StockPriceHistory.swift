//
//  StockPriceHistory.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import Foundation

struct StockPriceHistory: Decodable {
    
    let formattedPercentageChange: String
    let formattedPriceChange: String
    let priceHistory: [HistoricalPrice]
}

/// Leaving this in `internal` scope so the rest of the app can
/// access it
struct HistoricalPrice: Decodable {
    let midFormatted: String
    let mid: Double // TODO: improve precision by converting to Int
    let isLowPrice: Bool
    let isHighPrice: Bool
    let createdAt: String
}
