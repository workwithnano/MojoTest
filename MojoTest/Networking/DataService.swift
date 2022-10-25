//
//  DataService.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation

class DataService: ObservableObject {
    
    @Published private(set) var portfolioPositions = [Position]()
    
    /// In a real app, this stock data would be fetched on-demand, in order
    /// to provide real-time pricing data. Marking as "cached" to signify
    /// that this is a placeholder for such a stock API
    @Published private(set) var cachedStocks = [Stock]()
    
    @Published private(set) var isFetching = false
    private let dataStore = DataServiceStore()

    public init() { }
}

extension DataService {
    @MainActor
    func fetchAndParseData() async throws {
        isFetching = true
        defer { isFetching = false }

        let loadedData = try await dataStore.load()
        
        // Parse portfolio positions
        portfolioPositions = loadedData.positions
        print(portfolioPositions)
        // Parse cached stocks
        // Parse wallet details
    }
}

enum DataServiceError: Error {
    case statusNetworkingError
    case undecodedJsonError
    case decoderError
}
