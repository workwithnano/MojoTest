//
//  StockDetailView.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import SwiftUI

struct StockDetailView: View {
    
    @State private var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    var body: some View {
        Text("\(stock.athlete.fullName)")
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static let previewStock = Stock(currentPrice: 0, currentPriceFormatted: "$0.00", athlete: Athlete(firstName: "Sidd", lastName: "Finch", headShotUrl: "https://via.placeholder.com/350x254?text=Sidd+Finchs+Headshot", team: nil, playingNow: false))
    static var previews: some View {
        StockDetailView(stock: previewStock)
    }
}
