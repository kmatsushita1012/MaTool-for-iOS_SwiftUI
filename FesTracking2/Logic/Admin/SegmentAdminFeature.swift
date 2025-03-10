//
//  SegmentAdminReducer.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/03/06.
//
import ComposableArchitecture

struct SegmentAdminState: Equatable{
    var segment: Segment
    var isLoading: Bool
    var errorMessage: String?
}

enum SegmentAdminAction: Equatable{
    case switchCurve(Bool)
    case receivedCoordinates(Result<[Coordinate],RemoteError>)
}

struct SegmentAdminFeature:Reducer{
    @Dependency(\.remoteClient) var remoteClient
    
    var body:some Reducer<SegmentAdminState,SegmentAdminAction>{
        Reduce{ state, action in
            switch action{
            case .switchCurve(let value):
                let start = state.segment.start
                let end = state.segment.end
                if(value){
                    state.errorMessage = nil
                    state.isLoading = true
                    return .run {[] send in
                        let result = await self.remoteClient.getSegmentCoordinate(start, end)
                        await send(.receivedCoordinates(result))
                    }
                }else{
                    state.segment.coordinates = [start, end]
                    return .none
                }
            case .receivedCoordinates(.success(let coordinates)):
                state.isLoading = false
                state.segment.coordinates = coordinates
                return .none
            case .receivedCoordinates(.failure(let error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        
        }
    }
}
