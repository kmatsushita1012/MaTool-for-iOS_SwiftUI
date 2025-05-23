//
//  FesTracking2App.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/02/28.
//

import SwiftUI
import SwiftData
import FirebaseCore
import ComposableArchitecture
import AWSMobileClient

@main
struct FesTracking2App: App {
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(initialState:AppFeature.State()){ AppFeature()} )
        }
    }
}
