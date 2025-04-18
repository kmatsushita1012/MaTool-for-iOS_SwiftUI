//
//  Location.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/04/18.
//

import CoreLocation
import Combine
import ComposableArchitecture

final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    var value: AsyncValue<CLLocation> = .loading

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            value = .success(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        value = .failure(error)
    }
}


extension LocationClient {
    static func live(
        action: @escaping (AsyncValue<CLLocation>) -> Action, // success アクション
        interval: TimeInterval
    ) -> LocationClient {
        let manager = CLLocationManager()
        let delegate = LocationManagerDelegate()
        manager.delegate = delegate
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true


        return LocationClient(
            startTracking: {
                manager.startUpdatingLocation()
                DispatchQueue.main.async {
                    manager.requestLocation()
                }
                return Effect.run { send in
                    print("run")
                    for await _ in AsyncTimerSequence(interval: interval) {
                        print("timer")
                        let value = await MainActor.run { delegate.value }
                        await send(action(value))
                    }
                }

            },
            stopTracking: {
                manager.stopUpdatingLocation()

            }
        )
    }
}

struct AsyncTimerSequence: AsyncSequence {
    typealias Element = Void

    let interval: TimeInterval

    struct AsyncIterator: AsyncIteratorProtocol {
        let interval: TimeInterval

        mutating func next() async -> Void? {
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            return ()
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        .init(interval: interval)
    }
}

