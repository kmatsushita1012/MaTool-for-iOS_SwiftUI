//
//  AreaAdminView.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/04/16.
//

import SwiftUI
import ComposableArchitecture

struct AreaAdminView:View {
    let store: StoreOf<AreaAdminFeature>
    
    var body: some View {
        NavigationStack{
            ZStack {
                DistrictAdminMapView(
                    coordinates: store.coordinates,
                    isShownPolygon: true,
                    onMapLongPress: { coordinate in store.send(.mapTapped(coordinate))},
                )
                .edgesIgnoringSafeArea(.all)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        store.send(.undoButtonTapped)
                    }) {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .padding(.horizontal, 8)
                }
                ToolbarItem(placement: .principal) {
                    Text("町域編集")
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        store.send(.doneButtonTapped)
                    } label: {
                        Text("完了")
                            .bold()
                    }
                    .padding(.horizontal, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
}
