//
//  AuthFeature.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/03/20.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Login {
    
    @Dependency(\.authService) var authService
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    @Reducer
    enum Destination {
        case confirmSignIn(ConfirmSignIn)
        case resetPassword(ResetPassword)
    }
    
    @ObservableState
    struct State: Equatable {
        var id: String = ""
        var password: String = ""
        var isLoading: Bool = false
        var errorMessage: String? = nil
        @Presents var destination: Destination.State?
    }
    @CasePathable
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case homeTapped
        case signInTapped
        case received(SignInResult)
        case resetPasswordTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Login> {
        BindingReducer()
        Reduce{ state, action in
            switch action {
            case .binding(_):
                return .none
            case .signInTapped:
                state.isLoading = true
                return .run {[id = state.id, password = state.password] send in
                    let result = await authService.signIn(id, password: password)
                    await send(.received(result))
                }
            case .homeTapped:
                return .none
            case .resetPasswordTapped:
                state.destination = .resetPassword(ResetPassword.State(username: state.id))
                return .none
            case .received(.success(let userRole)):
                state.errorMessage = nil
                switch userRole {
                case .region(let id):
                    userDefaultsClient.setString(id, defaultRegionKey)
                    userDefaultsClient.setString(nil, defaultDistrictKey)
                    userDefaultsClient.setString(id, loginIdKey)
                    return .none
                case .district(let id):
                    userDefaultsClient.setString(id, defaultDistrictKey)
                    userDefaultsClient.setString(id, loginIdKey)
                    return .none
                case .guest:
                    return .none
                }
            case .received(.newPasswordRequired):
                state.destination = .confirmSignIn(ConfirmSignIn.State())
                state.isLoading = false
                state.errorMessage = nil
                return .none
            case .received(.failure(let error)):
                state.isLoading = false
                state.errorMessage = "ログインに失敗しました。\(error.localizedDescription)"
                return .none
            case .destination(.presented(let childAction)):
                switch childAction {
                case .resetPassword(.confirmResetReceived(.success)):
                    state.destination = nil
                    return .none
                case .confirmSignIn(.dismissTapped),
                    .resetPassword(.enterUsername(.dismissTapped)),
                    .resetPassword(.enterCode(.dismissTapped)):
                    state.destination = nil
                    return .none
                case .confirmSignIn,
                    .resetPassword:
                    return .none
                }
            case .destination(.dismiss):
                state.destination = nil
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension Login.Destination.State: Equatable {}
extension Login.Destination.Action: Equatable {}
