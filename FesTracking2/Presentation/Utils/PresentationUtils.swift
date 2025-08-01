//
//  Extensions.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/04/08.
//
import MapKit
import Foundation
import SwiftUI


func makeRegion(_ coordinates:[Coordinate], ratio :Double = 1.1) -> MKCoordinateRegion {
    let minLat = coordinates.map { $0.latitude }.min() ?? 0
    let maxLat = coordinates.map { $0.latitude }.max() ?? 0
    let minLon = coordinates.map { $0.longitude }.min() ?? 0
    let maxLon = coordinates.map { $0.longitude }.max() ?? 0

    let center = CLLocationCoordinate2D(
        latitude: (minLat + maxLat) / 2,
        longitude: (minLon + maxLon) / 2
    )
    let latitudeDelta = (maxLat - minLat) * ratio
    let longitudeDelta = (maxLon - minLon) * ratio
    let span = MKCoordinateSpan(
        latitudeDelta: spanDelta > latitudeDelta ? spanDelta: latitudeDelta,
        longitudeDelta: spanDelta > longitudeDelta ? spanDelta: longitudeDelta
    )

    return MKCoordinateRegion(center: center, span: span)
}

func makeRegion(origin: Coordinate?, spanDelta: CLLocationDegrees) -> MKCoordinateRegion? {
    if let origin = origin{
        return MKCoordinateRegion(
            center: origin.toCL(),
            span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
        )
    }
    return nil
}
