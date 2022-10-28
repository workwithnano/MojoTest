//
//  ContentView.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            PortfolioView()
                .tabItem {
                    Label("Portfolio", systemImage: "chart.pie.fill")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .customFont(.caption2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
