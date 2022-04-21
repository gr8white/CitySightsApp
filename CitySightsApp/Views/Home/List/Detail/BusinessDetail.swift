//
//  BusinessDetail.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/20/22.
//

import SwiftUI

struct BusinessDetail: View {
    var business: Business
    
    var body: some View {
        VStack (alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { reader in
                    // Image header
                    let uiImage = UIImage(data: business.imageData ?? Data())
                    Image(uiImage: uiImage ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: reader.size.width, height: reader.size.height)
                        .clipped()
                }
                
                // open/closed status
                ZStack (alignment: .leading) {
                    Rectangle()
                        .frame(height: 36)
                        .foregroundColor(business.isClosed! ? .gray : .blue)
                    
                    Text(business.isClosed! ? "Closed" : "Open")
                        .foregroundColor(.white)
                        .font(.caption)
                        .bold()
                        .padding(.leading)
                }
            }
            
            // Business details
            VStack (alignment: .leading) {
                // Business name
                Text(business.name ?? "")
                    .font(.headline)
                    .bold()
                
                // business address
                if business.location?.displayAddress != nil {
                    ForEach (business.location!.displayAddress!, id: \.self) { line in
                        VStack (alignment: .leading, spacing: 0) {
                            Text(line)
                        }
                    }
                }
                
                // rating
                Image("regular_\(business.rating ?? 0)")
            }.padding()
            
            Divider()
            
            // Option Rows
            HStack {
                // Option
                Text("Phone:")
                    .bold()
                
                // details
                Text(business.displayPhone ?? "")
                
                Spacer()
                
                // action button
                Link("Call", destination: URL(string: "tel:\(business.phone ?? "")")!)
            }.padding()
            
            Divider()
            
            HStack {
                // Option
                Text("Reviews:")
                    .bold()
                
                // details
                Text(String(business.reviewCount ?? 0))
                
                Spacer()
                
                // action button
                Link("Read", destination: URL(string: "\(business.url ?? "")")!)
            }.padding()
            
            Divider()
            
            HStack {
                // Option
                Text("Website:")
                    .bold()
                
                // details
                Text(business.url ?? "")
                    .lineLimit(1)
                
                Spacer()
                
                // action button
                Link("Visit", destination: URL(string: "\(business.url ?? "")")!)
            }.padding()
            
            Button  {
                // ShowDirections
            } label: {
                ZStack {
                    Rectangle()
                        .frame(height: 48)
                        .foregroundColor(.blue)
                    
                    Text("Get Directions")
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }.ignoresSafeArea(.all, edges: .top)
    }
}
