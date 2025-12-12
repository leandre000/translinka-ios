//
//  GoogleMapsService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import CoreLocation

class GoogleMapsService {
    static let shared = GoogleMapsService()
    
    private let apiKey = "YOUR_GOOGLE_MAPS_API_KEY" // Replace with actual API key
    private let baseURL = "https://maps.googleapis.com/maps/api"
    
    private init() {}
    
    // Get directions between two points
    func getDirections(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        mode: TravelMode = .driving
    ) async throws -> RouteResponse {
        let urlString = "\(baseURL)/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=\(mode.rawValue)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw MapsError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GoogleDirectionsResponse.self, from: data)
        
        return RouteResponse(
            distance: response.routes.first?.legs.first?.distance.value ?? 0,
            duration: response.routes.first?.legs.first?.duration.value ?? 0,
            polyline: response.routes.first?.overview_polyline.points ?? "",
            steps: response.routes.first?.legs.first?.steps ?? []
        )
    }
    
    // Get nearby bus stops
    func getNearbyBusStops(
        location: CLLocationCoordinate2D,
        radius: Int = 1000
    ) async throws -> [BusStop] {
        let urlString = "\(baseURL)/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&type=bus_station&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw MapsError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
        
        return response.results.map { place in
            BusStop(
                id: place.place_id,
                name: place.name,
                location: CLLocationCoordinate2D(
                    latitude: place.geometry.location.lat,
                    longitude: place.geometry.location.lng
                ),
                address: place.vicinity ?? "",
                rating: place.rating ?? 0.0
            )
        }
    }
    
    // Get place details with photos (for Rwandan locations)
    func getPlaceDetails(placeId: String) async throws -> PlaceDetails {
        let urlString = "\(baseURL)/place/details/json?place_id=\(placeId)&fields=name,geometry,photos,formatted_address,rating&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw MapsError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GooglePlaceDetailsResponse.self, from: data)
        
        let place = response.result
        var photoURLs: [String] = []
        
        if let photos = place.photos {
            for photo in photos.prefix(3) {
                let photoURL = "\(baseURL)/place/photo?maxwidth=800&photoreference=\(photo.photo_reference)&key=\(apiKey)"
                photoURLs.append(photoURL)
            }
        }
        
        return PlaceDetails(
            id: placeId,
            name: place.name,
            address: place.formatted_address ?? "",
            location: CLLocationCoordinate2D(
                latitude: place.geometry.location.lat,
                longitude: place.geometry.location.lng
            ),
            rating: place.rating ?? 0.0,
            photoURLs: photoURLs
        )
    }
    
    // Get street view image for Rwandan roads
    func getStreetViewImage(
        location: CLLocationCoordinate2D,
        size: String = "800x600",
        heading: Int = 0,
        pitch: Int = 0
    ) -> String {
        return "\(baseURL)/streetview?size=\(size)&location=\(location.latitude),\(location.longitude)&heading=\(heading)&pitch=\(pitch)&key=\(apiKey)"
    }
    
    // Search for places (especially Rwandan locations)
    func searchPlaces(
        query: String,
        location: CLLocationCoordinate2D? = nil,
        radius: Int = 5000
    ) async throws -> [Place] {
        var urlString = "\(baseURL)/place/textsearch/json?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&key=\(apiKey)"
        
        if let location = location {
            urlString += "&location=\(location.latitude),\(location.longitude)&radius=\(radius)"
        }
        
        guard let url = URL(string: urlString) else {
            throw MapsError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
        
        return response.results.map { place in
            Place(
                id: place.place_id,
                name: place.name,
                address: place.formatted_address ?? place.vicinity ?? "",
                location: CLLocationCoordinate2D(
                    latitude: place.geometry.location.lat,
                    longitude: place.geometry.location.lng
                ),
                rating: place.rating ?? 0.0,
                types: place.types ?? []
            )
        }
    }
}

enum TravelMode: String {
    case driving
    case walking
    case bicycling
    case transit
}

struct RouteResponse {
    let distance: Int // in meters
    let duration: Int // in seconds
    let polyline: String
    let steps: [RouteStep]
}

struct RouteStep {
    let distance: Int
    let duration: Int
    let instruction: String
    let polyline: String
}

struct BusStop: Identifiable {
    let id: String
    let name: String
    let location: CLLocationCoordinate2D
    let address: String
    let rating: Double
}

struct Place: Identifiable {
    let id: String
    let name: String
    let address: String
    let location: CLLocationCoordinate2D
    let rating: Double
    let types: [String]
}

struct PlaceDetails {
    let id: String
    let name: String
    let address: String
    let location: CLLocationCoordinate2D
    let rating: Double
    let photoURLs: [String]
}

enum MapsError: LocalizedError {
    case invalidURL
    case noResults
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noResults:
            return "No results found"
        case .apiError(let message):
            return message
        }
    }
}

// MARK: - Google API Response Models

struct GoogleDirectionsResponse: Codable {
    let routes: [GoogleRoute]
}

struct GoogleRoute: Codable {
    let legs: [GoogleLeg]
    let overview_polyline: GooglePolyline
}

struct GoogleLeg: Codable {
    let distance: GoogleDistance
    let duration: GoogleDuration
    let steps: [GoogleStep]
}

struct GoogleStep: Codable {
    let distance: GoogleDistance
    let duration: GoogleDuration
    let html_instructions: String
    let polyline: GooglePolyline
}

struct GoogleDistance: Codable {
    let value: Int
    let text: String
}

struct GoogleDuration: Codable {
    let value: Int
    let text: String
}

struct GooglePolyline: Codable {
    let points: String
}

struct GooglePlacesResponse: Codable {
    let results: [GooglePlace]
}

struct GooglePlace: Codable {
    let place_id: String
    let name: String
    let formatted_address: String?
    let vicinity: String?
    let geometry: GoogleGeometry
    let rating: Double?
    let types: [String]?
}

struct GoogleGeometry: Codable {
    let location: GoogleLocation
}

struct GoogleLocation: Codable {
    let lat: Double
    let lng: Double
}

struct GooglePlaceDetailsResponse: Codable {
    let result: GooglePlaceDetails
}

struct GooglePlaceDetails: Codable {
    let name: String
    let formatted_address: String?
    let geometry: GoogleGeometry
    let rating: Double?
    let photos: [GooglePhoto]?
}

struct GooglePhoto: Codable {
    let photo_reference: String
}

