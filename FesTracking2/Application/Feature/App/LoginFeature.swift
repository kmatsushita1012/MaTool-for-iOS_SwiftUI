//
//  AuthFeature.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/03/20.
//

import Foundation
import ComposableArchitecture
import AWSMobileClient

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable {
        var username: String = ""
        var password: String = ""
        var errorMessage: String?
    }
    @CasePathable
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case signInButtonTapped
        case received(Result<UserRole, AWSCognitoError>)
        case homeTapped
    }
    
    @Dependency(\.awsCognitoClient) var awsCognitoClient
    @Dependency(\.accessToken) var accessToken

    var body: some ReducerOf<LoginFeature> {
        BindingReducer()
        Reduce{ state, action in
            switch action {
            case .binding(_):
                return .none
            case .signInButtonTapped:
                return .run {[username = state.username, password = state.password] send in
                    let result = await awsCognitoClient.signIn(username, password)
                    await send(.received(result))
                }
            case .received(.success(_)):
                state.errorMessage = nil
                return .run { send in
                    let result = await awsCognitoClient.getTokens()
                    switch result {
                    case .success(let tokens):
                        if let token = tokens.accessToken?.tokenString {
                            accessToken.value = token
                        } else {
                            print("No access token found")
                        }
                    case .failure(_):
                        return
                    }
                }
            case .received(.failure(let error)):
                state.errorMessage = error.localizedDescription
                return .none
            case .homeTapped:
                return .none
            }
        }
    }
}
