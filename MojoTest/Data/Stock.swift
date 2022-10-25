//
//  Stock.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

//"currentPrice": 73.968,
//     "currentPriceFormatted": "$73.97",
//     "athlete": {
//       "name": "Tom Brady",
//       "espnHeadshotUrl": "https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/2330.png&w=350&h=254"
//     }



/// Open questions:
/// - Is `Athlete` the de-facto unique identifier for every `Stock` object?
///

struct Stock {
    // TODO: track price with precision, in Cents (Int) rather than Dollars (Double)
    let currentPrice: Double?
    let currentPriceFormatted: String?
    let athlete: Athlete?
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
        athlete = try container.decodeIfPresent(Athlete.self, forKey: .athlete)
    }
}
