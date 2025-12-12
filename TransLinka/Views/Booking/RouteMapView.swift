//
//  RouteMapView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI
import MapKit

struct RouteMapView: View {
    let route: Route
    @StateObject private var mapsService = GoogleMapsService.shared
    @State private var routePolyline: MKPolyline?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: [
                    RouteAnnotation(
                        id: "origin",
                        coordinate: route.departureLocation ?? CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619),
                        title: route.origin,
                        type: .origin
                    ),
                    RouteAnnotation(
                        id: "destination",
                        coordinate: route.arrivalLocation ?? CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619),
                        title: route.destination,
                        type: .destination
                    )
                ]) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    VStack {
                        Image(systemName: annotation.type == .origin ? "mappin.circle.fill" : "flag.fill")
                            .font(.title)
                            .foregroundColor(annotation.type == .origin ? Theme.primaryBlue : Theme.accentGreen)
                            .background(Color.white.clipShape(Circle()))
                        
                        Text(annotation.title)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(4)
                    }
                }
            }
            .onAppear {
                // loadRoute() // Commented out - requires Google Maps API
                isLoading = false
            }
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(Theme.cornerRadiusMedium)
            }
        }
        .navigationTitle("Route Map")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Commented out - requires Google Maps API
    /*
    private func loadRoute() {
        guard let origin = route.departureLocation,
              let destination = route.arrivalLocation else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let routeResponse = try await mapsService.getDirections(
                    from: origin,
                    to: destination,
                    mode: .driving
                )
                
                await MainActor.run {
                    // Update region to show entire route
                    let centerLat = (origin.latitude + destination.latitude) / 2
                    let centerLng = (origin.longitude + destination.longitude) / 2
                    let latDelta = abs(origin.latitude - destination.latitude) * 1.5
                    let lngDelta = abs(origin.longitude - destination.longitude) * 1.5
                    
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng),
                        span: MKCoordinateSpan(latitudeDelta: max(latDelta, 0.1), longitudeDelta: max(lngDelta, 0.1))
                    )
                    
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
    */
}

// RouteAnnotation is now in Views/Components/
// Import it from there

