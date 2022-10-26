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
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "\(totalPortfolioGainFormatted.starts(with: "-") ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")")
                            .scaleEffect(x: 0.75, y: 0.75, anchor: .center) // Make the arrow 75% the size of the rest of the label, per design spec
                            .foregroundStyle(totalPortfolioGainFormatted.starts(with: "-") ? Color.negativeColor : Color.positiveColor)
                        Text(totalPortfolioGainFormatted)
                            .foregroundStyle(totalPortfolioGainFormatted.starts(with: "-") ? Color.negativeColor : Color.positiveColor)
                        Text("Total")
                            .foregroundColor(Color.gray)
                            .fontWeight(.regular)
                    }
                    .customFont(.title3)
                    
                    Menu() {
                        Button(PositionFormat.dollars.rawValue) {
                            positionFormat = .dollars
                        }
                        Button(PositionFormat.percentage.rawValue) {
                            positionFormat = .percentage
                        }
                    } label: {
                        Text(positionFormat.rawValue)
                        Image(systemName: "chevron.down")
                    }
                    .menuStyle(DropdownMenu())
                    
                    // Using a `LazyVStack` instead of `List` for formatting
                    // purposes. `List` views are themselves ScrollViews, which
                    // we do not want. We want the entire view to scroll inside
                    // the `NavigationStack` as a single view.
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(dataService.portfolioPositionsGroupedByType) { typeGroup in
                            Section() {
                                ForEach(typeGroup.positions) { position in
                                    NavigationLink(value: position.stock) {
                                        AsyncImage(url: URL(string: "\(position.stock.athlete.headShotUrl ?? "https://via.placeholder.com/350x254?text=No+Headshot+Provided")"))
                                            { phase in
                                                if let image = phase.image {
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                  } else if phase.error != nil { // Error downloading
                                                    Image(systemName: "figure.american.football")
                                                          .resizable()
                                                          .aspectRatio(contentMode: .fit)
                                                  } else { // Empty
                                                    Image(systemName: "figure.american.football")
                                                          .resizable()
                                                          .aspectRatio(contentMode: .fit)
                                                  }
                                            }
                                            .frame(width: 60, height: 44)
                                        Text("\(position.stock.athlete.firstInitialWithPeriod) \(position.stock.athlete.lastName)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundStyle(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 0))
                                    Divider()
                                        .frame(alignment: .top)
                                }
                            } header: {
                                Text(typeGroup.type.rawValue.capitalized) // Capital-casing per design spec
                                    .frame(alignment: .leading)
                                    .customFont(.subheadline)
                                    .padding(EdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0))
                                Divider()
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
            .padding()
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
