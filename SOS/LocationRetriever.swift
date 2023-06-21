//
//  LocationRetriever.swift
//  SOS
//
//  Created by Neha Patil on 3/21/23.
//

import Foundation
import CoreLocation

struct LocationRetriever{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let first = locations.first else{
            return
        }
        
        let lat = first.coordinate.latitude
        let longit = first.coordinate.longitude
        print(lat)
        print(longit)
        
    }
    
    func getLocation (){
        
        let manager: CLLocationManager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
       
    }
}






