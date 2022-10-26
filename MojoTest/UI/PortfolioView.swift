//
//  PortfolioView.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import SwiftUI
import UIKit

struct PortfolioView: View {
    
    @StateObject var dataService = DataService()
    
    /// Sets the initial position format, and updates related UI whenever the
    /// value is set
    @State var positionFormat: PositionFormat = .dollars {
        didSet {
            switch positionFormat {
            case .percentage:
                totalPortfolioGainFormatted = dataService.totalPortfolioGainPercentageFormatted
            case .dollars:
                totalPortfolioGainFormatted = dataService.totalPortfolioGainDollarsFormatted
            }
        }
    }
    @State var totalPortfolioGainFormatted: String = ""
    
    @State private var stockSelection: UUID?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(totalPortfolioGainFormatted)
                    Text("Total")
                }
                Menu(positionFormat.rawValue) {
                    Button(PositionFormat.dollars.rawValue) {
                        positionFormat = .dollars
                    }
                    Button(PositionFormat.percentage.rawValue) {
                        positionFormat = .percentage
                    }
                }
                List(selection: $stockSelection) {
                    ForEach(dataService.portfolioPositionsGroupedByType) { typeGroup in
                        Section(header: Text(typeGroup.type.rawValue)) {
                            ForEach(typeGroup.positions) { position in
                                NavigationLink("\(position.stock.athlete.firstInitialWithPeriod) \(position.stock.athlete.lastName)", value: position.stock)
                            }
                        }
                    }
                }
                .navigationDestination(for: Stock.self) { stock in
                    StockDetailView(stock: stock)
                }
                
                NavigationLink(destination: PortfolioDetailsView()) {
                    Label("Portfolio Details", systemImage: "chevron.right")
                }
                
                Text("Available Funds")
                
                HStack {
                    Text("Total")
                    Text(dataService.walletTotalBalanceFormatted)
                }
            }
                .navigationTitle("Portfolio")
                .isHidden(dataService.isFetching)
            ProgressView()
                .isHidden(!dataService.isFetching)
        }
        .task {
            Task {
                try? await dataService.fetchAndParseData()
                positionFormat = self.positionFormat
            }
        }
        .onAppear() {
            NavigationBarStyles.navigationBarFontSetAppearance()
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
