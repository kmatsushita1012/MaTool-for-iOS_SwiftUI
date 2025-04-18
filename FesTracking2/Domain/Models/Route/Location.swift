//
//  Location.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/03/09.
//

struct Location: Codable{
    let districtId: String
    let coordinate: Coordinate
    let time: DateTime
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.districtId == rhs.districtId && lhs.time == rhs.time
    }
}

extension Location {
    static let sample = Self(districtId: "johoku", coordinate: Coordinate.sample, time: DateTime.sample)
}

struct RouteLocationResponse: Codable{
    let route: Route
    let location: Location
}

extension RouteLocationResponse: Equatable {
    static func == (lhs: RouteLocationResponse, rhs: RouteLocationResponse) -> Bool {
        return lhs.route == rhs.route && lhs.location == rhs.location
    }
}
