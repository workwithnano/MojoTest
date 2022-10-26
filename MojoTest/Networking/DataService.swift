//
//  DataService.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

class DataService: ObservableObject {
    
    @Published private(set) var portfolioPositions = [Position]()
    @Published private(set) var portfolioPositionsGroupedByType = [PositionGroup]()
    
    @Published private(set) var totalPortfolioGainDollarsFormatted: String = ""
    @Published private(set) var totalPortfolioGainPercentageFormatted: String = ""
    @Published private(set) var totalPortfolioValueFormatted: String = ""
    @Published private(set) var walletTotalBalanceFormatted: String = ""
    
    /// In a real app, this stock data would be fetched on-demand, in order
    /// to provide real-time pricing data. Marking as "cached" to signify
    /// that this is a placeholder for such a stock API
    @Published private(set) var cachedStocks = [Stock]()
    
    @Published private(set) var isFetching = true
    private let dataStore = DataServiceStore()

    public init() { }
    
    private static func groupPositionsByType(positions: [Position]) -> [PositionGroup] {
        var groupedPositions = [PositionGroup]()
        // Initialize all type groups in order
        for type in PositionType.allCases {
            groupedPositions.append(PositionGroup(type: type, positions: [Position]()))
        }
        for position in positions {
            // Since we already initialized all type groups above,
            // we can force unwrap the array elements safely
            let typeIndex = PositionType.allCases.firstIndex(of: position.type)!
            groupedPositions[typeIndex].positions.append(position)
        }
        return groupedPositions
    }
}

extension DataService {
    @MainActor
    func fetchAndParseData() async throws {
        isFetching = true
        defer { isFetching = false }

        let loadedData = try await dataStore.load()
        
        // Parse portfolio positions
        portfolioPositions = loadedData.positions
        portfolioPositionsGroupedByType = DataService.groupPositionsByType(positions: loadedData.positions)
        
        // Parse wallet details
        totalPortfolioGainDollarsFormatted = loadedData.totalPortfolioGainDollarsFormatted
        totalPortfolioGainPercentageFormatted = loadedData.totalPortfolioGainPercentageFormatted
        totalPortfolioValueFormatted = loadedData.totalPortfolioValueFormatted
        walletTotalBalanceFormatted = loadedData.walletTotalBalanceFormatted
    }
}

enum DataServiceError: Error {
    case statusNetworkingError
    case undecodedJsonError
    case decoderError
}
