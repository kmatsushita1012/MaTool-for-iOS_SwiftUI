//
//  Route.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/03/09.
//

import Foundation

struct PublicRoute: Codable, Equatable, Identifiable{
    let id: String
    let districtId: String
    let districtName: String
    let date: SimpleDate
    let title: String
    let description: String?
    let points: [Point]
    let segments: [Segment]
    let start: SimpleTime
    let goal: SimpleTime
}

extension PublicRoute {
    func text(format: String) -> String {
        var result = ""
        var i = format.startIndex
        
        while i < format.endIndex {
            let char = format[i]
            
            let nextIndex = format.index(after: i)
            let hasNext = nextIndex < format.endIndex
            let nextChar = hasNext ? format[nextIndex] : nil

            switch char {
            case "D":
                result += districtName
            case "T":
                result += title
            case "y":
                result += String(date.year)
            case "m":
                if nextChar == "2" {
                    result += String(format: "%02d", date.month)
                    i = format.index(after: nextIndex)
                    continue
                } else {
                    result += String(date.month)
                }
            case "d":
                if nextChar == "2" {
                    result += String(format: "%02d", date.day)
                    i = format.index(after: nextIndex)
                    continue
                } else {
                    result += String(date.day)
                }
            default:
                result += String(char)
            }

            i = format.index(after: i)
        }
        return result
    }
    
    func toModel() -> Route {
        return Route(
            id: self.id,
            districtId: self.districtId,
            date: self.date,
            title: self.title,
            description: self.description,
            points: self.points,
            segments: self.segments,
            start: self.start,
            goal: self.goal
        )
    }
    
    init(from route: Route, name: String) {
        id = route.id
        districtId = route.districtId
        districtName = name
        date = route.date
        title = route.title
        description = route.description
        points = route.points
        segments = route.segments
        start = route.start
        goal =  route.goal
    }
}


extension PublicRoute {
    static let sample = Self(
        id: UUID().uuidString,
        districtId: "Johoku",
        districtName: "城北町",
        date: SimpleDate.sample,
        title: "午後",
        description: "省略",
        points: [
            Point(id: UUID().uuidString, coordinate: Coordinate(latitude: 34.777681, longitude: 138.007029), title: "出発", time: SimpleTime(hour: 9, minute: 0),isPassed: true),
            Point(id: UUID().uuidString, coordinate: Coordinate(latitude: 34.778314, longitude: 138.008176), title: "到着", description: "お疲れ様です", time: SimpleTime(hour: 12, minute: 0),isPassed: true)
        ],
        segments: [
            Segment(id: UUID().uuidString, start: Coordinate(latitude: 34.777681, longitude: 138.007029), end: Coordinate(latitude: 34.778314, longitude: 138.008176), coordinates: [
                Coordinate(latitude: 34.777681, longitude: 138.007029),
                Coordinate(latitude: 34.777707, longitude: 138.008183),
                Coordinate(latitude: 34.778314, longitude: 138.008176)
            ], isPassed: true)
        ],
        
        start: SimpleTime.sample,
        goal: SimpleTime(
            hour:12,
            minute: 00
        )
    )
}
