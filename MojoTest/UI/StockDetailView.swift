//
//  StockDetailView.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import SwiftUI

struct StockDetailView: View {
    
    private var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        // TODO: How to handle a missing price, "<No Price>" is not acceptable
                        Text("\(stock.currentPriceFormatted ?? "<No Price Data Found for \(stock.athlete.fullName)>")")
                            .customFont(.largeTitle)
                        FormattedAmountText(formattedAmount: "\(stock.priceHistory?.formattedPriceChange ?? "<No Price Change Data Found for \(stock.athlete.fullName)>") (\(stock.priceHistory?.formattedPercentageChange ?? "<No Percentage Change Data Found for \(stock.athlete.fullName)>"))")
                            .customFont(.body)
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        }
        VStack {
            Divider()
            Button {
                // do nothing for now
            } label: {
                Text("Trade")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .customFont(.body)
            .fontWeight(.bold)
            .tint(stock.priceHistory?.formattedPercentageChange.starts(with: "-") ?? false ? Color.negativeColor : Color.positiveColor)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 12))
            .padding(EdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24))
            Divider()
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundLightGray.clipped())
        .navigationTitle("\(stock.athlete.fullName)")
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static let previewStock = Stock(currentPrice: 0, currentPriceFormatted: "$0.00", athlete: Athlete(firstName: "Sidd", lastName: "Finch", headShotUrl: "https://via.placeholder.com/350x254?text=Sidd+Finchs+Headshot", team: nil, playingNow: false))
    static var previews: some View {
        StockDetailView(stock: previewStock)
    }
}
