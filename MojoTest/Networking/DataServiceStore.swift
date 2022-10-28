//
//  DataService.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

internal actor DataServiceStore {
    private var loadedFlatData: FlatData?
    private var url: URL {
        urlComponents.url!
    }

    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "takehome-assets.s3.us-east-2.amazonaws.com"
        components.path = "/takehome_mobile_data.json"
        return components
    }

    /// This is meant to fetch the über-JSON that contains portfolio data
    /// (positions, wallet info) as well as the detailed data on one specific
    /// player, Tom Brady, best quarterback of all time.
    ///
    /// Since it's not normalized, or at least the schema doesn't make a ton
    /// of sense to me, I'm running it through multiple decoders to turn it
    /// into Swift struct instances, rather than one nested-data-understanding
    /// decoder.
    func load() async throws -> FlatData {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard
            let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw DataServiceError.statusNetworkingError
        }
        var flatData: FlatData?
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .ISO8601WithFractionalSeconds
            flatData = try decoder.decode(FlatData.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        loadedFlatData = flatData!
        loadedFlatData = DataServiceStore.shoehorn(stockPriceHistory: loadedFlatData!.stockPriceHistoryChange, into: loadedFlatData!)
        loadedFlatData = DataServiceStore.shoehorn(currentStockPriceDataFrom: loadedFlatData!.stock, into: loadedFlatData!)
        return loadedFlatData!
    }
    
    /// Takes the hanging `stockPriceHistoryChange` object from the root `data`
    /// object from the sample API and attaches it to the Tom Brady position's stock
    static func shoehorn(stockPriceHistory: StockPriceHistory, into flatData: FlatData) -> FlatData {
        
        var mutatedFlatData = flatData
        mutatedFlatData.stock.priceHistory = stockPriceHistory
        
        for (i, _) in mutatedFlatData.positions.enumerated() {
            // TODO: use proper object comparison, even though technically
            // I had to infer that this price history belongs to Tom Brady
            // so maybe this is exactly the right type of comparison ;-)
            if mutatedFlatData.positions[i].stock.athlete.fullName == "Tom Brady" {
                mutatedFlatData.positions[i].stock.priceHistory = stockPriceHistory
            }
        }
        
        return mutatedFlatData
    }
    
    /// Takes the hanging current price data from hte `stock` object from the root `data`
    /// object from the sample API and attaches it to the Tom Brady position's stock
    static func shoehorn(currentStockPriceDataFrom stockWithPriceData: Stock, into flatData: FlatData) -> FlatData {
        var mutatedFlatData = flatData
        
        for (i, _) in mutatedFlatData.positions.enumerated() {
            if mutatedFlatData.positions[i].stock == stockWithPriceData {
                mutatedFlatData.positions[i].stock.currentPriceFormatted = stockWithPriceData.currentPriceFormatted
                mutatedFlatData.positions[i].stock.currentPrice = stockWithPriceData.currentPrice
            }
            
        }
        
        return mutatedFlatData
    }
}
