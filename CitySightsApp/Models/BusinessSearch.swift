//
//  BusinessSearch.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/18/22.
//

import Foundation

struct BusinessSearch: Decodable {
    var businesses = [Business]()
    var total = 0
    var region = Region()
}

struct Region: Decodable {
    var center = Coordinate()
}
