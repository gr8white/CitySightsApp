//
//  ContentModel.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/13/22.
//

import Foundation
import CoreLocation

class ContentModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    
    override init() {
        // Super references the parent class (NSObject) and calls its default init
        super.init()
        
        // Set ContentModel as the delegate of the LocationManager
        locationManager.delegate = self
        
        // Runs the pop up to request location access from the user
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Location manager delegate methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationState = locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            // We have access to location
            
            // Starts to geolocate the user, after receiving permission
            locationManager.startUpdatingLocation()
        } else if locationManager.authorizationStatus == .denied {
            // We don't have access to the user's location
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Give us the location of the user for the model to use
        let userLocation = locations.first
        
        if userLocation != nil {
            // Stop requesting the location if we only need it once
            locationManager.stopUpdatingLocation()
            
            //TODO: Once we have user location, send it to the yelp api
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            getBusinesses(category: Constants.restaurantKey, location: userLocation!)
        }
        
    }
    
    // MARK: - Yelp API Methods
    
    func getBusinesses(category: String, location: CLLocation) {
        var urlComponents = URLComponents(string: Constants.apiUrl)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        
        let url = urlComponents?.url
        
        if let url = url {
            // Create url request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.APIKey)", forHTTPHeaderField: "Authorization")
            
            // Get URLSession
            let session = URLSession.shared
            
            // Create data task
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                // Check that there isnt an error
                
                if error == nil {
                    do {
                        // parse JSON
                        let decoder = JSONDecoder()
                        
                        let result = try decoder.decode(BusinessSearch.self, from: data!)
                        
                        // Sort business by distance
                        let businesses = result.businesses.sorted { (b1, b2) -> Bool in
                            return b1.distance ?? 0 < b2.distance ?? 0
                        }
                        
                        // Call get image function on the business
                        for b in businesses {
                            b.getImageData()
                        }

                        DispatchQueue.main.async {
                            
                            // Assign results to the appropriate property
                            
                            switch category {
                            case Constants.sightsKey:
                                self.sights = businesses
                            case Constants.restaurantKey:
                                self.restaurants = businesses
                            default:
                                break
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            
            // Start the data task
            dataTask.resume()
        }
    }
    
}
