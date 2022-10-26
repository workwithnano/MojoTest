//
//  FlatData.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import Foundation

/// This is a temporary hack, since the data is not normalized, but
/// I want the data models to be used (along with their `Decoders`)
///
struct FlatData {
    let stockPriceHistoryChange: StockPriceHistory
    
    /// > Note: This is mutatable due to the need to shoehorn in
    /// the price history from a hanging object in the flat JSON
    var stock: Stock
    
    /// > Note: This is mutatable due to the need to shoehorn in
    /// the price history from a hanging object in the flat JSON
    var positions: [Position]
    
    let totalPortfolioGainDollarsFormatted: String
    let totalPortfolioGainPercentageFormatted: String
    let totalPortfolioValueFormatted: String
    let walletTotalBalanceFormatted: String
}

extension FlatData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case data
        
        enum NestedKeys: String, CodingKey {
            case stockPriceHistoryChange
            case stock
            case positions
            case totalPortfolioGainDollarsFormatted
            case totalPortfolioGainPercentageFormatted
            case totalPortfolioValueFormatted
            case wallet
            
            enum WalletKeys: String, CodingKey {
                case totalBalanceFormatted
            }
            
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedData = try container.nestedContainer(keyedBy: CodingKeys.NestedKeys.self, forKey: .data)
        
        stockPriceHistoryChange = try nestedData.decode(StockPriceHistory.self, forKey: .stockPriceHistoryChange)
        stock = try nestedData.decode(Stock.self, forKey: .stock)
        positions = try nestedData.decode([Position].self, forKey: .positions)
        totalPortfolioGainDollarsFormatted = try nestedData.decode(String.self, forKey: .totalPortfolioGainDollarsFormatted)
        totalPortfolioGainPercentageFormatted = try nestedData.decode(String.self, forKey: .totalPortfolioGainPercentageFormatted)
        totalPortfolioValueFormatted = try nestedData.decode(String.self, forKey: .totalPortfolioValueFormatted)
        
        let walletContainer = try nestedData.nestedContainer(keyedBy: CodingKeys.NestedKeys.WalletKeys.self, forKey: .wallet)
        walletTotalBalanceFormatted = try walletContainer.decode(String.self, forKey: .totalBalanceFormatted)
        
    }
}
