//
//  PortfolioView.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import SwiftUI

struct PortfolioView: View {
    
    @StateObject var dataService = DataService()
    
    @State var positionFormat: PositionFormat = .dollars {
        didSet {
            // TODO: Update the UI
        }
    }
    
    @State private var stockSelection: UUID?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("$XX.XX")
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
            }
                .navigationTitle("Portfolio")
                .isHidden(dataService.isFetching)
            ProgressView()
                .isHidden(!dataService.isFetching)
        }
        .task {
            Task {
                try? await dataService.fetchAndParseData()
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
