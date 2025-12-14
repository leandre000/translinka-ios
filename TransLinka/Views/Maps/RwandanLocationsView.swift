//
//  RwandanLocationsView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI
import MapKit

/// View showing Rwandan cities and bus stops
/// NOTE: Street view requires Google Maps API - currently disabled
struct RwandanLocationsView: View {
    @StateObject private var locationService = LocationService.shared
    // @StateObject private var mapsService = GoogleMapsService.shared // Commented out - requires API
    @State private var selectedCity: City?
    @State private var showStreetView = false
    @State private var streetViewLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Major Cities Section
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Major Cities in Rwanda")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(locationService.rwandanCities, id: \.name) { city in
                            CityCard(city: city) {
                                selectedCity = city
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    // Popular Bus Stops
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Popular Bus Stops")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(locationService.rwandanBusStops, id: \.name) { busStop in
                            BusStopLocationCard(busStop: busStop) {
                                // Street view commented out - requires Google Maps API
                                // streetViewLocation = busStop.coordinate
                                // showStreetView = true
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Rwandan Locations")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedCity) { city in
                CityDetailView(city: city)
            }
            .sheet(isPresented: $showStreetView) {
                if let location = streetViewLocation {
                    StreetViewImageView(location: location)
                }
            }
        }
    }
}

// CityCard and BusStopLocationCard are now in Views/Components/
// Import them from there

struct CityDetailView: View {
    let city: City
    @StateObject private var mapsService = GoogleMapsService.shared
    @State private var placeDetails: PlaceDetails?
    @State private var isLoading = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .padding()
                } else if let details = placeDetails {
                    VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                        // City Images (Street View)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.spacingMedium) {
                                ForEach(details.photos, id: \.self) { urlString in
                                    AsyncImage(url: URL(string: urlString)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        SkeletonLoader()
                                    }
                                    .frame(width: 300, height: 200)
                                    .cornerRadius(Theme.cornerRadiusMedium)
                                }
                            }
                            .padding()
                        }
                        
                        // City Info - Use CardView for consistency
                        CardView {
                            VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                                Text(details.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(details.address)
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                if details.rating > 0 {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        Text("\(details.rating, specifier: "%.1f")")
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Map View
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: details.location,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )), annotationItems: [details]) { detail in
                            MapAnnotation(coordinate: detail.location) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(Theme.primaryBlue)
                            }
                        }
                        .frame(height: 300)
                        .cornerRadius(Theme.cornerRadiusMedium)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(city.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadCityDetails()
            }
        }
    }
    
    private func loadCityDetails() {
        Task {
            // Search for city place
            do {
                let places = try await mapsService.searchPlaces(query: city.name)
                if let place = places.first {
                    let details = try await mapsService.getPlaceDetails(placeId: place.id)
                    await MainActor.run {
                        placeDetails = details
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}

struct StreetViewImageView: View {
    let location: CLLocationCoordinate2D
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingMedium) {
                    // Street View Image (stubbed - requires API key)
                    Color.gray.opacity(0.3)
                        .frame(height: 200)
                        .overlay(
                            Text("Street View\n(Requires API Key)")
                                .foregroundColor(.gray)
                        )
                    .cornerRadius(Theme.cornerRadiusMedium)
                    .padding()
                    
                    Text("Street View")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("Street View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


