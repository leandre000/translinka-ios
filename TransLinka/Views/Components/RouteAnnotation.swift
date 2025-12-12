//
//  RouteAnnotation.swift
//  TransLinka
//
//  Map annotation for route origin and destination
//

import Foundation
import MapKit

/// Map annotation for route markers
struct RouteAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
    let type: AnnotationType
    
    enum AnnotationType {
        case origin
        case destination
    }
}

