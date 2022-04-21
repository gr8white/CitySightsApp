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
    @State var selectedBusiness: Business?
    
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
                            Button {
                                self.isMapShowing = true
                            } label: {
                                Text("Switch to map view")
                            }
                        }
                        
                        Divider()
                        
                        BusinessList()
                    }
                    .padding([.horizontal, .top])
                    .navigationBarHidden(true)
                } else {
                    // show map
                    ZStack (alignment: .top) {
                        BusinessMap(selectedBusiness: $selectedBusiness)
                            .ignoresSafeArea()
                            .sheet(item: $selectedBusiness) { business in
                                BusinessDetail(business: business)
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .frame(height: 48)
                            
                            HStack {
                                Image(systemName: "location")
                                Text("San Francisco")
                                Spacer()
                                Button {
                                    self.isMapShowing = false
                                } label: {
                                    Text("Switch to list view")
                                }
                            }
                            .padding()
                        }
                        .padding()
                    }
                    .navigationBarHidden(true)
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
