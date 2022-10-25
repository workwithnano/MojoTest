//
//  PortfolioView.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import SwiftUI

struct PortfolioView: View {
    
    @StateObject var dataService = DataService()
    
    var body: some View {
        ZStack {
            Text("Data fetched")
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
