//
//  RealTimeTrackingView.swift
//  TransLinka
//
//  NOTE: This view requires backend integration for real-time bus tracking
//  Currently shows simulated tracking data
//

import SwiftUI
import MapKit
import CoreLocation

/// Real-time bus tracking view
/// TODO: Integrate with backend API for live bus locations
struct RealTimeTrackingView: View {
    let route: Route
    @StateObject private var trackingViewModel = RealTimeTrackingViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            // Map with bus location
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: trackingViewModel.busLocations) { busLocation in
                MapAnnotation(coordinate: busLocation.coordinate) {
                    VStack {
                        Image(systemName: "bus.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Theme.primaryBlue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                        
                        Text(busLocation.busNumber)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(4)
                    }
                }
            }
            .onAppear {
                trackingViewModel.startTracking(route: route)
            }
            .onDisappear {
                trackingViewModel.stopTracking()
            }
            
            // Tracking Info Overlay
            VStack {
                Spacer()
                
                VStack(spacing: Theme.spacingMedium) {
                    // Bus Status
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bus \(trackingViewModel.currentBus?.busNumber ?? route.busNumber)")
                                .font(.headline)
                            
                            if let bus = trackingViewModel.currentBus {
                                Text("\(Int(bus.speed)) km/h")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        // ETA
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("ETA")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            
                            Text(trackingViewModel.eta)
                                .font(.headline)
                                .foregroundColor(Theme.primaryBlue)
                        }
                    }
                    .padding()
                    .cardStyle()
                    
                    // Next Stop
                    if let nextStop = trackingViewModel.nextStop {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Theme.accentOrange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Next Stop")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                                
                                Text(nextStop.name)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Text(nextStop.distance.distanceString)
                                .font(.headline)
                                .foregroundColor(Theme.primaryBlue)
                        }
                        .padding()
                        .cardStyle()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Live Tracking")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@MainActor
class RealTimeTrackingViewModel: ObservableObject {
    @Published var busLocations: [BusLocation] = []
    @Published var currentBus: BusLocation?
    @Published var nextStop: NextStop?
    @Published var eta: String = "Calculating..."
    
    private var trackingTimer: Timer?
    private var currentRoute: Route?
    
    func startTracking(route: Route) {
        currentRoute = route
        
        // Simulate bus movement
        let initialLocation = BusLocation(
            busNumber: route.busNumber,
            coordinate: route.departureLocation ?? CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619),
            speed: 0,
            heading: 0,
            timestamp: Date()
        )
        
        busLocations = [initialLocation]
        currentBus = initialLocation
        
        // Update bus location every 5 seconds
        trackingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateBusLocation()
        }
        
        updateETA()
        updateNextStop()
    }
    
    func stopTracking() {
        trackingTimer?.invalidate()
        trackingTimer = nil
    }
    
    private func updateBusLocation() {
        guard let bus = currentBus, let route = currentRoute else { return }
        
        // Simulate bus moving towards destination
        let destination = route.arrivalLocation ?? CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619)
        
        let latDiff = destination.latitude - bus.coordinate.latitude
        let lngDiff = destination.longitude - bus.coordinate.longitude
        
        let newLat = bus.coordinate.latitude + (latDiff * 0.01)
        let newLng = bus.coordinate.longitude + (lngDiff * 0.01)
        
        let newLocation = BusLocation(
            busNumber: bus.busNumber,
            coordinate: CLLocationCoordinate2D(latitude: newLat, longitude: newLng),
            speed: 45, // km/h
            heading: calculateHeading(from: bus.coordinate, to: destination),
            timestamp: Date()
        )
        
        currentBus = newLocation
        busLocations = [newLocation]
        
        updateETA()
        updateNextStop()
    }
    
    private func calculateHeading(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let dLng = (to.longitude - from.longitude) * .pi / 180
        
        let y = sin(dLng) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng)
        
        return atan2(y, x) * 180 / .pi
    }
    
    /// Update estimated time of arrival based on current bus location and speed
    private func updateETA() {
        guard let bus = currentBus, let route = currentRoute else { return }
        let destination = route.arrivalLocation ?? CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619)
        
        let distance = calculateDistance(from: bus.coordinate, to: destination)
        let timeInSeconds = (distance / 1000) / (bus.speed / 3600) // Convert to seconds
        eta = Date.formatDuration(timeInSeconds)
    }
    
    private func updateNextStop() {
        // Get nearest bus stop
        if let bus = currentBus {
            let nearestStop = LocationService.shared.getNearestBusStop(to: bus.coordinate)
            if let stop = nearestStop {
                let distance = LocationService.shared.getDistance(from: bus.coordinate, to: stop.coordinate)
                let eta = distance / 1000 / (bus.speed / 3600) // Calculate ETA in seconds
                nextStop = NextStop(
                    name: stop.name,
                    coordinate: stop.coordinate,
                    distance: distance,
                    eta: eta
                )
            }
        }
    }
    
    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
}

// BusLocation and NextStop are now in Models/LocationModels.swift
// Route location extensions are now in Models/Route.swift

