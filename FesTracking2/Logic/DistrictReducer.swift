//
//  RouteSummariesReducer.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/03/02.
//

import ComposableArchitecture
import Foundation
import Dependencies
import DependenciesMacros

@Reducer
struct DistrictReducer{
    @Dependency(\.remoteClient) var remoteClient
//    var remoteClient: RemoteClient
    
    struct State: Equatable {
        var district: District
        var summaries: [RouteSummary]
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case setDistrict(District)
        case fetchSummmariesResponse(Result<[RouteSummary], RemoteError>)
    }

    struct Environment {
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var remoteClient: RemoteClient
    }
    
    func reduce(into state: inout State, action: Action, environment: Environment) -> Effect<Action> {
            switch action {
            case let .setDistrict(district):
                state.district = district
                state.isLoading = true
                state.errorMessage = nil
                return .run {[state = state] send in
                    let result = await self.remoteClient.getRouteSummaries(state.district.id)
                    await send(.fetchSummmariesResponse(result))
                }
            case let .fetchSummmariesResponse(.success(summaries)):
                state.isLoading = false
                state.summaries = summaries
                return .none
                
            case let .fetchSummmariesResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    
}

