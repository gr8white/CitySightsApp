//
//  LaunchView.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/13/22.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        // Detect the authorization of the user's location
        if model.authorizationState == .notDetermined {
            // If undetermined show onboarding
            
        } else if model.authorizationState == .authorizedAlways || model.authorizationState == .authorizedWhenInUse {
            // If already allowed show home view
            HomeView()
        
        } else if model.authorizationState == .denied {
            // If denied, show denied view
            
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(ContentModel())
    }
}
