//
//  HomeView.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/18/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ContentModel
    @State var isMapShowing = false
    
    var body: some View {
        if model.restaurants.count != 0 || model.sights.count != 0 {
            
            NavigationView {
                if !isMapShowing {
                    // show list
                    VStack (alignment: .leading) {
                        HStack {
                            Image(systemName: "location")
                            Text("San Francisco")
                            Spacer()
                            Text("Switch to map view")
                        }
                        
                        Divider()
                        
                        BusinessList()
                    }
                    .padding([.horizontal, .top])
                    .navigationBarHidden(true)
                } else {
                    // show map
                    
                }
            }
        } else {
            ProgressView()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
