//
//  LocationManager.swift
//  SOS
//
//  Created by Neha Patil on 4/10/23.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    
    let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion.defaultRegion()
    
    override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    private func checkAuthorization(){
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("location is restricted")
            case .denied:
                print("You have denied the app location authorization")
        case .authorizedAlways, .authorizedWhenInUse:
            guard let location = locationManager.location else {
                return
            }
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
            print("location")
            @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        DispatchQueue.main.async { [weak self] in
                    self?.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
                }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
