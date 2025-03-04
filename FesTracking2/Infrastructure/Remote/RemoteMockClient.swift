//
//  MockRepository.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/03/02.
//

import Foundation
import Combine
import Dependencies
extension RemoteClient: TestDependencyKey {
    internal static let testValue = normal
    internal static let previewValue = normal
}


let normal = RemoteClient(
    getRegions:{
        return Result.success([Region(id: UUID(), name: "掛川祭", description: "省略", imagePath: nil)])
    },
    getDistricts: {_ in
        return Result.success([District(id: UUID(), name: "城北町", description: "省略", imagePath: nil)])
    },
    getRouteSummaries: {_ in
        return Result.success([RouteSummary(id: UUID(), date: SimpleDate(year: 2025, month: 10, day: 12), title: "午前")])
        
    },
    getRoute: {_ in
        return Result.success(
            Route(
                id: UUID(),
                points: [
                    Point(coordinate: Coordinate(latitude: 34.777681, longitude: 138.007029), title: "出発", time: Time(hour: 9, minute: 0),isPassed: true),
                    Point(coordinate: Coordinate(latitude: 34.778314, longitude: 138.008176), title: "到着", description: "お疲れ様です", time: Time(hour: 12, minute: 0),isPassed: true)
                ],
                segments: [
                    Segment(
                        [
                            Coordinate(latitude: 34.777681, longitude: 138.007029),
                            Coordinate(latitude: 34.777730, longitude: 138.008174),
                            Coordinate(latitude: 34.778314, longitude: 138.008176),
                        ]
                    )
                ],
                current: Location(coordinate: Coordinate(latitude: 34.777681, longitude: 138.007029),time: Time(hour: 9, minute: 1)),
                date: SimpleDate(year: 2025, month: 10, day: 12),
                title: "午後",
                description: "省略",
                start: Time(
                    hour:9,
                    minute:00
                ),
                goal: Time(
                    hour:12,
                    minute: 00
                )
            )
        )
    })
