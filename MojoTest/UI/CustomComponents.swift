//
//  CustomComponents.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/27/22.
//

import SwiftUI

struct AthleteHeadshotImage: View {
    
    let stock: Stock
    
    var body: some View {
        AsyncImage(url: URL(string: "\(stock.athlete.headShotUrl ?? "https://via.placeholder.com/350x254?text=No+Headshot+Provided")"))
            { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .bottom)
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
    }
}
