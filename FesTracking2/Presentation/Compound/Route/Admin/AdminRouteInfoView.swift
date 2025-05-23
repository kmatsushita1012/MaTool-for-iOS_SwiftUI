//
//  Untitled.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/04/11.
//

import SwiftUI
import ComposableArchitecture

struct AdminRouteInfoView: View{
    @Bindable var store: StoreOf<AdminRouteInfoFeature>
    
    var body: some View{
        NavigationStack{
            Form{
                Section(header: Text("日付")){
                    DatePicker(
                        "日付を選択",
                        selection: $store.route.date.fullDate,
                        displayedComponents: [.date]
                    )
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                }
                Section(header: Text("タイトル")) {
                    TextField("タイトルを入力（土曜午前等）",text: $store.route.title)
                }
                Section(header: Text("説明")) {
                    TextEditor(text: $store.route.description.nonOptional)
                        .frame(height:60)
                }
                Section(header: Text("経路")) {
                    Button(action: {
                        store.send(.mapButtonTapped)
                    }) {
                        Label("地図で編集", systemImage: "map")
                            .font(.body)
                    }
                }
                Section(header: Text("時刻") ) {
                    DatePicker(
                        "開始時刻",
                        selection: $store.route.start.fullDate,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    DatePicker(
                        "終了時刻",
                        selection: $store.route.goal.fullDate,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                }
                Section {
                    NavigationItem(
                        title: "経路図出力（PDF）",
                        onTap: { store.send(.exportTapped) }
                    )
                }
                if case .edit(_,_,_) = store.mode {
                    Section {
                        Text("削除")
                            .onTapGesture {
                                store.send(.deleteTapped)
                            }
                            .foregroundStyle(.red)
                    }
                }
                if let errorMessage = store.errorMessage{
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") {
                        store.send(.cancelButtonTapped)
                    }
                    .padding(8)
                }
                ToolbarItem(placement: .principal) {
                    Text("編集")
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        store.send(.saveButtonTapped)
                    } label: {
                        Text(store.mode.isCreate ? "作成" : "保存")
                            .bold()
                    }
                    .padding(8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(
                item: $store.scope(state: \.destination?.map, action: \.destination.map)
            ) { store in
                AdminRouteMapView(store: store)
            }
            .fullScreenCover(
                item: $store.scope(state: \.destination?.export, action: \.destination.export)
            ) { store in
                AdminRouteExportView(store: store)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
