//
//  CitySightsApp.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/13/22.
//

import SwiftUI

@main
struct CitySightsApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
