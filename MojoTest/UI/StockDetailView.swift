//
//  StockDetailView.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    
    private var stock: Stock
    
    @State private var chartLowValue: Double = 0
    @State private var chartHighValue: Double = 1000 // TODO: What is a rational default y-axis upper bound for the chart?
    @State private var chartPriceMaximums = [HistoricalPrice]()
    
    @State private var selectedDateRange: Int? = StockPriceHistoryDateRange.allCases.firstIndex(of: .oneMonth)
    
    init(stock: Stock) {
        self.stock = stock
    }
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(spacing: 0) {
                            // TODO: How to handle a missing price, "<No Price>" is not acceptable
                            Text("\(stock.currentPriceFormatted ?? "<No Price Data Found for \(stock.athlete.fullName)>")")
                                .customFont(.largeTitle)
                            FormattedAmountText(formattedAmount: "\(stock.priceHistory?.formattedPriceChange ?? "<No Price Change Data Found for \(stock.athlete.fullName)>") (\(stock.priceHistory?.formattedPercentageChange ?? "<No Percentage Change Data Found for \(stock.athlete.fullName)>"))")
                                .customFont(.body)
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                        }
                        Spacer()
                        AthleteHeadshotImage(stock: stock)
                            .frame(width: 90, height: 66)
                    }
                    
                    Chart {
                        ForEach(stock.priceHistory?.historicalPrices ?? [HistoricalPrice](), id: \.createdAt) { price in
                            LineMark(x: .value("Date", price.createdAt), y: .value("Price", price.mid))
                        }
                        // Uncomment below to experiment with interpolation/smoothing between points
                        // .interpolationMethod(.catmullRom)
                        ForEach(chartPriceMaximums, id: \.createdAt) { priceMaximum in
                            PointMark(x: .value("Date", priceMaximum.createdAt), y: .value("Price", priceMaximum.mid))                                .annotation(position: (priceMaximum.isHighPrice ? .top : .bottom), alignment: .center, spacing: 0) {
                                Text("\(priceMaximum.midFormatted)")
                                    .customFont(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .symbol {
                                 // Remove the default symbol with a no-op `symbol`. Only using the `.annotation` above
                            }
                        }
                    }
                    .chartYScale(domain: chartLowValue...chartHighValue)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .frame(height: geometry.size.width*(5/9)) // make the chart a 9:5 ratio per design
                    .padding(EdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 0)) // TODO: Guidance needed for vertical positioning of chart
                    
                    VStack(alignment: .center) {
                        SegmentedMojoPicker(titles: StockPriceHistoryDateRange.allCases.map({ $0.rawValue }), selectedIndex: $selectedDateRange)
                    }
                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)) // Extra top padding since the chart annotations escape below the bounds of the chart canvas
                    .frame(maxWidth: .infinity)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            }
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
            .mojoButtonRoundedRect()
            .padding(EdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24))
            Divider()
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundLightGray.clipped())
        .navigationTitle("\(stock.athlete.fullName)")
        .onAppear {
            // for SwiftUI initialization-order reasons, need to update @State
            // properties outside of initialization or else they won't update
            setChartRanges()
        }
    }
    
    func setChartRanges() {
        guard let priceHistory = stock.priceHistory?.historicalPrices else {
            return // Consider throwing in Development and logging in Production here.
        }
        for historicalPrice in priceHistory {
            // This assumes we can trust the isLowPrice and isHighPrice variables from the API
            if historicalPrice.isLowPrice {
                chartLowValue = historicalPrice.mid
                chartPriceMaximums.append(historicalPrice)
            }
            if historicalPrice.isHighPrice {
                chartHighValue = historicalPrice.mid
                chartPriceMaximums.append(historicalPrice)
            }
        }
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static let previewStock = Stock(currentPrice: 0, currentPriceFormatted: "$0.00", athlete: Athlete(firstName: "Sidd", lastName: "Finch", headShotUrl: "https://via.placeholder.com/350x254?text=Sidd+Finchs+Headshot", team: nil, playingNow: false))
    static var previews: some View {
        StockDetailView(stock: previewStock)
    }
}
