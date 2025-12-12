//
//  LocationService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: Error?
    
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    // Rwandan major cities coordinates
    let rwandanCities: [City] = [
        City(name: "Kigali", coordinate: CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619)),
        City(name: "Butare", coordinate: CLLocationCoordinate2D(latitude: -2.5967, longitude: 29.7389)),
        City(name: "Gisenyi", coordinate: CLLocationCoordinate2D(latitude: -1.6944, longitude: 29.2564)),
        City(name: "Ruhengeri", coordinate: CLLocationCoordinate2D(latitude: -1.4997, longitude: 29.6344)),
        City(name: "Byumba", coordinate: CLLocationCoordinate2D(latitude: -1.5769, longitude: 30.0675)),
        City(name: "Cyangugu", coordinate: CLLocationCoordinate2D(latitude: -2.4842, longitude: 28.9075)),
        City(name: "Kibungo", coordinate: CLLocationCoordinate2D(latitude: -2.1597, longitude: 30.5428)),
        City(name: "Kibuye", coordinate: CLLocationCoordinate2D(latitude: -2.0597, longitude: 29.3481))
    ]
    
    // Major bus stops in Rwanda
    let rwandanBusStops: [BusStopLocation] = [
        BusStopLocation(name: "Nyabugogo Bus Station", coordinate: CLLocationCoordinate2D(latitude: -1.9436, longitude: 30.0525), city: "Kigali"),
        BusStopLocation(name: "Kacyiru Bus Stop", coordinate: CLLocationCoordinate2D(latitude: -1.9361, longitude: 30.0811), city: "Kigali"),
        BusStopLocation(name: "Remera Bus Stop", coordinate: CLLocationCoordinate2D(latitude: -1.9500, longitude: 30.1000), city: "Kigali"),
        BusStopLocation(name: "Kimisagara Bus Stop", coordinate: CLLocationCoordinate2D(latitude: -1.9583, longitude: 30.0667), city: "Kigali"),
        BusStopLocation(name: "Butare Bus Station", coordinate: CLLocationCoordinate2D(latitude: -2.5967, longitude: 29.7389), city: "Butare"),
        BusStopLocation(name: "Gisenyi Bus Station", coordinate: CLLocationCoordinate2D(latitude: -1.6944, longitude: 29.2564), city: "Gisenyi"),
        BusStopLocation(name: "Ruhengeri Bus Station", coordinate: CLLocationCoordinate2D(latitude: -1.4997, longitude: 29.6344), city: "Ruhengeri")
    ]
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) // in meters
    }
    
    func getNearestBusStop(to location: CLLocationCoordinate2D) -> BusStopLocation? {
        return rwandanBusStops.min { stop1, stop2 in
            getDistance(from: location, to: stop1.coordinate) < getDistance(from: location, to: stop2.coordinate)
        }
    }
    
    func getNearestCity(to location: CLLocationCoordinate2D) -> City? {
        return rwandanCities.min { city1, city2 in
            getDistance(from: location, to: city1.coordinate) < getDistance(from: location, to: city2.coordinate)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

struct City {
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct BusStopLocation {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let city: String
}

