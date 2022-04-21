//
//  BusinessMap.swift
//  CitySightsApp
//
//  Created by Derrick White on 4/20/22.
//

import SwiftUI
import MapKit

struct BusinessMap: UIViewRepresentable {
    @EnvironmentObject var model: ContentModel
    @Binding var selectedBusiness: Business?
    
    var locations: [MKPointAnnotation] {
        // create set of annotations based on businesses
        var annotations = [MKPointAnnotation]()
        
        for business in model.restaurants + model.sights {
            if let lat = business.coordinates?.latitude, let lon = business.coordinates?.longitude {
                // create a new annotation
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                a.title = business.name ?? ""
                
                annotations.append(a)
            }
        }
        
        return annotations
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Make the user show up on the map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        // Set the region
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Remove annotations from the map
        uiView.removeAnnotations(uiView.annotations)
        
        // Add annotations based on the business
        uiView.showAnnotations(self.locations, animated: true)
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(map: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var map: BusinessMap
        
        init(map: BusinessMap) {
            self.map = map
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // if the annotation is the user blue dot, return nil
            if annotation is MKUserLocation { return nil }
            
            // Check if there is a reusable annotation view
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseId)
            
            if annotationView == nil {
                // Create an annotation view
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseId)
                
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                // There is a reusable annotation view
                annotationView!.annotation = annotation
            }
            
            // Return the annotation view
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            // User tapped on the annotation view
            
            // Get the business object that this annotation represents
            // Loop through the businesses in the model and find a match
            for business in map.model.restaurants + map.model.sights {
                if business.name == view.annotation?.title {
                    map.selectedBusiness = business
                    return
                }
            }
            
            // Set the selectedBusiness property to that business object
        }
    }
}
