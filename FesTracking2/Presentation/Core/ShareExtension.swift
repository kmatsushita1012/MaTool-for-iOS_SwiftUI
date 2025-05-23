//
//  Extensions.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/04/08.
//
import MapKit
import Foundation
import SwiftUI

extension Coordinate {
    func toCL()->CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    static func fromCL(_ coordinate: CLLocationCoordinate2D)->Coordinate{
        return Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension SimpleTime {
    var toDate: Date {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components) ?? now
    }
    
    static func fromDate(_ date: Date) -> SimpleTime {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return SimpleTime(hour: components.hour ?? 0, minute: components.minute ?? 0)
    }
}



