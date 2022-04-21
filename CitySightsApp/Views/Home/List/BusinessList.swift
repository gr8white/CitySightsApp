//
//  BusinessList.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/18/22.
//

import SwiftUI

struct BusinessList: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            LazyVStack (alignment: .leading, pinnedViews: [.sectionHeaders]) {
                BusinessSection(title: "Restaurants", businesses: model.restaurants)
                
                BusinessSection(title: "Sights", businesses: model.sights)
            }
        }
    }
    
    @ViewBuilder func BusinessSection(title: String, businesses: [Business]) -> some View {
        Section (header: BusinessHeader(title: title)) {
            ForEach(businesses) { business in
                NavigationLink {
                    BusinessDetail(business: business)
                } label: {
                    BusinessRow(business: business)
                }
            }
        }
    }
    
    @ViewBuilder func BusinessHeader(title: String) -> some View{
        ZStack (alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
        }
    }
}
