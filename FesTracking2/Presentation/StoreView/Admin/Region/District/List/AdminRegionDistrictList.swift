//
//  AdminRegionDistrictList.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/05/12.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AdminRegionDistrictList {
    
    @ObservableState
    struct State: Equatable {
        let district: PublicDistrict
        let routes: [RouteSummary]
        var isApiLoading: Bool = false
        var isExportLoading: Bool = false
        var folder: ExportedFolder? = nil
        @Presents var export: AdminRouteExport.State?
        @Presents var alert: Alert.State?
        var isLoading: Bool {
            isApiLoading || isExportLoading
        }
    }
    
    @CasePathable
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case exportTapped(RouteSummary)
        case exportPrepared(Result<PublicRoute,ApiError>)
        case dismissTapped
        case batchExportTapped
        case batchExportPrepared(Result<[URL], ApiError>)
        case export(PresentationAction<AdminRouteExport.Action>)
        case alert(PresentationAction<Alert.Action>)
    }
    
    @Dependency(\.apiRepository) var apiRepository
    @Dependency(\.authService) var authService
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<AdminRegionDistrictList> {
        BindingReducer()
        Reduce{ state, action in
            switch action {
            case .binding:
                return .none
            case .exportTapped(let route):
                state.isApiLoading = true
                return .run{ send in
                    let result = await apiRepository.getRoute(route.id, authService.getAccessToken())
                    await send(.exportPrepared(result))
                }
            case .exportPrepared(.success(let route)):
                state.isApiLoading = false
                state.export = .init(route: route)
                return .none
            case .exportPrepared(.failure(let error)):
                state.isApiLoading = false
                state.alert = Alert.error("情報の取得に失敗しました。\n\(error.localizedDescription)")
                return .none
            case .dismissTapped:
                return .run { _ in
                    await dismiss()
                }
            case .batchExportTapped:
                state.isExportLoading = true
                return batchExportEffect(state.routes)
            case .batchExportPrepared(.success(let value)):
                state.isExportLoading = false
                state.folder = ExportedFolder(value)
                return .none
            case .batchExportPrepared(.failure(let error)):
                state.alert = Alert.error("出力に失敗しました。\n\(error.localizedDescription)")
                return .none
            case .export(.presented(.dismissTapped)),
                .export(.dismiss):
                state.export = nil
                return .none
            case .export:
                return .none
            case .alert:
                state.alert = nil
                return .none
            }
        }
        .ifLet(\.$export, action: \.export){
            AdminRouteExport()
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    func batchExportEffect(_ items: [RouteSummary]) -> Effect<Action> {
        .run { send in
            let accessToken = await authService.getAccessToken()
            var urls: [URL] = []
            //非同期並列にするとBEでアクセス過多
            for item in items {
                let routeResult = await apiRepository.getRoute(item.id, accessToken)
                guard let route = routeResult.value else { continue }
                let snapshotter = RouteSnapshotter(route)
                guard let image = try? await snapshotter.take() else { continue }
                guard let url = snapshotter.createPDF(with: image, path: "\(route.text(format: "D_y-m-d_T")).pdf") else { continue }
                urls.append(url)
            }
            await send(.batchExportPrepared(.success(urls)))
        }
    }
}
