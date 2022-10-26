//
//  Stock.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

/// Open questions:
/// - Is `Athlete` the de-facto unique identifier for every `Stock` object?
///

struct Stock {
    
    // TODO: track price with precision, in Cents (Int) rather than Dollars (Double)
    
    /// > Note: This is mutatable due to the need to shoehorn in
    /// the price history from a hanging object in the flat JSON
    var currentPrice: Double?
    
    /// > Note: This is mutatable due to the need to shoehorn in
    /// the price history from a hanging object in the flat JSON
    var currentPriceFormatted: String?
    
    let athlete: Athlete
    
    /// > Note: This is mutatable due to the need to shoehorn in
    /// the price history from a hanging object in the flat JSON
    var priceHistory: StockPriceHistory? = nil
}

extension Stock: Decodable {
    enum CodingKeys: String, CodingKey {
        case currentPrice
        case currentPriceFormatted
        case athlete
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPrice = try container.decodeIfPresent(Double.self, forKey: .currentPrice)
        currentPriceFormatted = try container.decodeIfPresent(String.self, forKey: .currentPriceFormatted)
        athlete = try container.decode(Athlete.self, forKey: .athlete)
    }
}

extension Stock: Identifiable, Hashable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Athlete {
        return athlete
    }
}
