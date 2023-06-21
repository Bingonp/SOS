//
//  MKCoordinateRegion+Extension.swift
//  SOS
//
//  Created by Neha Patil on 4/10/23.
//

import Foundation
import MapKit

extension MKCoordinateRegion{
    
    static func defaultRegion() -> MKCoordinateRegion {
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.03121860), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        }
    
    
}
