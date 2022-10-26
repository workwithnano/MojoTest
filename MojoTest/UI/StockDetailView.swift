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
        VStack {
            // TODO: How to handle a missing price, "<No Price>" is not acceptable
            Text("\(stock.currentPriceFormatted ?? "<No Price Data Found for \(stock.athlete.fullName)>")")
            Text("\(stock.priceHistory?.formattedPercentageChange ?? "<No Percentage Change Data Found for \(stock.athlete.fullName)>")")
        }
            .navigationTitle("\(stock.athlete.fullName)")
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static let previewStock = Stock(currentPrice: 0, currentPriceFormatted: "$0.00", athlete: Athlete(firstName: "Sidd", lastName: "Finch", headShotUrl: "https://via.placeholder.com/350x254?text=Sidd+Finchs+Headshot", team: nil, playingNow: false))
    static var previews: some View {
        StockDetailView(stock: previewStock)
    }
}
