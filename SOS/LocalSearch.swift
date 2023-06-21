//
//  LocalSearch.swift
//  SOS
//
//  Created by Neha Patil on 4/10/23.
//

import Foundation
import MapKit
import Combine


class LocalSearch: ObservableObject {
    var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()
    @Published var landmarkHostpital: Landmark?
    @Published var landmarksHospital: [Landmark] = []
    @Published var landmarkPolice: Landmark?
    @Published var landmarksPolice: [Landmark] = []
    let locationManager = LocationManager()
    var cancellables = Set<AnyCancellable>()
    init () {
        locationManager.$region.assign(to:\.region, on: self).store(in: &cancellables)
    }
    
    func searchHospital(query: String) -> [Landmark]{
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = locationManager.region
        
        let search = MKLocalSearch(request: request)
        search.start{ response,error in
            if let response = response {
                let mapItems = response.mapItems
                self.landmarksHospital = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
            }
        }
        return landmarksHospital
    }
    
    func searchPolice(query: String) -> [Landmark]{
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = locationManager.region
        
        let search = MKLocalSearch(request: request)
        search.start{ response,error in
            if let response = response {
                let mapItems = response.mapItems
                self.landmarksPolice = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
            }
        }
        return landmarksPolice
    }
    
}
