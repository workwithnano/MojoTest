//
//  Position.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

//"currentValueFormatted": "$997.61",
//       "shareQuantity": 13.51873839,
//       "totalGainDollarsFormatted": "-$0.1095",
//       "totalGainPercentageFormatted": "-0.24%",
//       "type": "LONG",
//       "stock": {
//         "athlete": {
//           "firstName": "Tom",
//           "lastName": "Brady",
//           "playingNow": false,
//           "espnHeadshotUrl": "https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/2330.png&w=350&h=254",
//           "team": {
//             "playingToday": false
//           }
//         }
//       }

enum PositionType: String, Codable {
    case long = "LONG"
    case short = "SHORT"
}

struct Position {
    let shareQuantity: Double // TODO: Increase precision, use Ints
    let totalGainDollarsFormatted: String?
    let totalGainPercentageFormatted: String?
    let type: PositionType
    let stock: Stock
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
