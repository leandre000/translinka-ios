//
//  MapView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var locationService = LocationService.shared
    @StateObject private var mapsViewModel = MapsViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -1.9441, longitude: 30.0619), // Kigali
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var selectedBusStop: BusStopLocation?
    @State private var showBusStops = true
    @State private var showRoute = false
    @State private var routeStart: CLLocationCoordinate2D?
    @State private var routeEnd: CLLocationCoordinate2D?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Map View
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: showBusStops ? locationService.rwandanBusStops : []) { busStop in
                MapAnnotation(coordinate: busStop.coordinate) {
                    Button(action: {
                        selectedBusStop = busStop
                    }) {
                        VStack(spacing: 0) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(Theme.primaryBlue)
                                .background(Color.white.clipShape(Circle()))
                            
                            Text(busStop.name)
                                .font(.caption)
                                .padding(4)
                                .background(Color.white)
                                .cornerRadius(4)
                                .shadow(radius: 2)
                        }
                    }
                }
            }
            .onAppear {
                locationService.requestLocationPermission()
                locationService.startLocationUpdates()
                
                if let location = locationService.currentLocation {
                    region.center = location.coordinate
                }
            }
            .onChange(of: locationService.currentLocation) { newLocation in
                if let location = newLocation {
                    withAnimation {
                        region.center = location.coordinate
                    }
                }
            }
            
            // Controls
            VStack {
                HStack {
                    Spacer()
                    
                    VStack(spacing: Theme.spacingSmall) {
                        // Toggle Bus Stops
                        Button(action: {
                            withAnimation {
                                showBusStops.toggle()
                            }
                        }) {
                            Image(systemName: showBusStops ? "mappin.circle.fill" : "mappin.circle")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Theme.primaryBlue)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        
                        // Current Location
                        Button(action: {
                            if let location = locationService.currentLocation {
                                withAnimation {
                                    region.center = location.coordinate
                                }
                            }
                        }) {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Theme.accentGreen)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Bus Stop Info Card
                if let busStop = selectedBusStop {
                    BusStopCard(busStop: busStop) {
                        selectedBusStop = nil
                    }
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRoute) {
            RouteDetailsView(start: routeStart!, end: routeEnd!)
        }
    }
}

struct BusStopCard: View {
    let busStop: BusStopLocation
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(busStop.name)
                        .font(.headline)
                    
                    Text(busStop.city)
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            PrimaryButton(
                title: "Get Directions",
                action: {
                    // Navigate to this bus stop using Apple Maps
                }
            )
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadiusMedium)
        .shadow(radius: 10)
        .padding()
    }
}

@MainActor
class MapsViewModel: ObservableObject {
    @Published var routes: [RouteResponse] = []
    @Published var isLoading = false
    
    func loadRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async {
        isLoading = true
        do {
            let route = try await GoogleMapsService.shared.getDirections(from: from, to: to, mode: .driving)
            routes = [route]
        } catch {
            print("Error loading route: \(error)")
        }
        isLoading = false
    }
}

struct RouteDetailsView: View {
    let start: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
    @StateObject private var viewModel = MapsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if let route = viewModel.routes.first {
                    VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                        RouteInfoRow(icon: "arrow.right", label: "Distance", value: "\(route.distance / 1000) km")
                        RouteInfoRow(icon: "clock", label: "Duration", value: formatDuration(route.duration))
                        
                        Button("Start Navigation") {
                            // Open in Maps app
                            openInMaps()
                        }
                        .primaryButtonStyle()
                        .padding()
                    }
                    .padding()
                }
            }
            .navigationTitle("Route Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadRoute(from: start, to: end)
                }
            }
        }
    }
    
    /// Format duration using extension
    private func formatDuration(_ seconds: Int) -> String {
        Date.formatDuration(TimeInterval(seconds))
    }
    
    private func openInMaps() {
        let startPlacemark = MKPlacemark(coordinate: start)
        let endPlacemark = MKPlacemark(coordinate: end)
        
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMaps(with: [startMapItem, endMapItem], launchOptions: options)
    }
}

struct RouteInfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.primaryBlue)
                .frame(width: 24)
            
            Text(label)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .cardStyle()
    }
}

